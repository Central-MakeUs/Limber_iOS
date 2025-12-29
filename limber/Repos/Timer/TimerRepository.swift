//
//  TimerRepository.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation
import FirebaseCore
import FirebaseFirestore

protocol TimerRepositoryProtocol {
  func createTimer(_ dto: TimerRequestDto) async throws -> TimerResponseDto
  func getUserTimers(userId: String) async throws -> [TimerResponseDto]
  func getTimer(by id: Int) async throws -> TimerResponseDto
  func getFetchAll(dto: TimerAllFetchStatusRequest) async throws -> TimerAllFetchStatusResponse
  func updateTimerStatus(id: Int, dto: TimerStatusUpdateDto) async throws -> TimerResponseDto
  func getTimerStatus(id: Int) async throws -> TimerStatus
  func deleteTimer(id: Int) async throws
  func unlockTimer(timerId: String, failReason: String) async throws
}
typealias TimerResponseList = [TimerResponseDto]

final class TimerRepository: TimerRepositoryProtocol {
  private let db = Firestore.firestore()

  init() {}

  func createTimer(_ dto: TimerRequestDto) async throws -> TimerResponseDto {
    let timerId = Self.makeId()
    var status: TimerStatus = .ON

    let overlap = try await hasOverlappingRunningTimer(
      userId: dto.userId,
      startTime: dto.startTime,
      endTime: dto.endTime,
      excludingId: nil
    )
    if overlap {
      if dto.timerCode == .SCHEDULED {
        status = .OFF
      } else {
        throw TimerRepositoryError.httpError(code: 409)
      }
    }

    if dto.timerCode == .SCHEDULED, Self.isNowWithinRange(startTime: dto.startTime, endTime: dto.endTime) {
      status = .OFF
    }

    let ref = timerDocRef(userId: dto.userId, timerId: timerId)
    let now = Timestamp(date: Date())
    let data: [String: Any] = [
      "id": timerId,
      "userId": dto.userId,
      "title": dto.title,
      "focusTypeId": dto.focusTypeId,
      "repeatCycleCode": dto.repeatCycleCode.rawValue,
      "repeatDays": dto.repeatDays,
      "startTime": dto.startTime,
      "endTime": dto.endTime,
      "status": status.rawValue,
      "timerCode": dto.timerCode.rawValue,
      "delFlag": "N",
      "createdAt": now,
      "updatedAt": now,
    ]
    try await FirestoreAsync.setData(ref, data: data)

    return TimerResponseDto(
      id: timerId,
      title: dto.title,
      focusTypeId: dto.focusTypeId,
      repeatCycleCode: dto.repeatCycleCode,
      repeatDays: dto.repeatDays,
      startTime: dto.startTime,
      endTime: dto.endTime,
      status: status,
      timerCode: dto.timerCode
    )
  }
  
  func getUserTimers(userId: String) async throws -> [TimerResponseDto] {
    let query = timersCollection(userId: userId)
      .whereField("delFlag", isEqualTo: "N")
      .whereField("timerCode", isEqualTo: TimerCode.SCHEDULED.rawValue)
    let snapshot = try await FirestoreAsync.getDocuments(query)
    return snapshot.documents.compactMap { Self.timerDto(from: $0) }
  }
  
  func getTimer(by id: Int) async throws -> TimerResponseDto {
    let userId = try await currentUserId()
    let snapshot = try await FirestoreAsync.getDocument(timerDocRef(userId: userId, timerId: id))
    guard let dto = Self.timerDto(from: snapshot) else {
      throw TimerRepositoryError.decodingError
    }
    return dto
  }
  
  func updateTimerStatus(id: Int, dto: TimerStatusUpdateDto) async throws -> TimerResponseDto {
    let userId = try await currentUserId()
    let ref = timerDocRef(userId: userId, timerId: id)
    let snapshot = try await FirestoreAsync.getDocument(ref)
    guard var current = Self.timerDto(from: snapshot) else {
      throw TimerRepositoryError.decodingError
    }
    if current.status == dto.status {
      return current
    }
    if dto.status == .ON {
      let overlap = try await hasOverlappingRunningTimer(
        userId: userId,
        startTime: current.startTime,
        endTime: current.endTime,
        excludingId: current.id
      )
      if overlap || Self.isNowWithinRange(startTime: current.startTime, endTime: current.endTime) {
        throw TimerRepositoryError.httpError(code: 409)
      }
    }
    try await FirestoreAsync.updateData(ref, data: [
      "status": dto.status.rawValue,
      "updatedAt": Timestamp(date: Date()),
    ])
    current.status = dto.status
    return current
  }

  func getFetchAll(dto: TimerAllFetchStatusRequest) async throws -> TimerAllFetchStatusResponse {
    let query = timersCollection(userId: dto.userId)
      .whereField("delFlag", isEqualTo: "N")
      .whereField("timerCode", isEqualTo: dto.timerCode)
    let snapshot = try await FirestoreAsync.getDocuments(query)
    let batch = db.batch()
    snapshot.documents.forEach { doc in
      batch.updateData(["status": dto.status], forDocument: doc.reference)
    }
    try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
      batch.commit { error in
        if let error {
          cont.resume(throwing: error)
        } else {
          cont.resume(returning: ())
        }
      }
    }
    if let first = snapshot.documents.first, let firstDto = Self.timerDto(from: first) {
      return TimerAllFetchStatusResponse(
        id: firstDto.id,
        title: firstDto.title,
        focusTypeId: firstDto.focusTypeId,
        repeatCycleCode: firstDto.repeatCycleCode.rawValue,
        repeatDays: firstDto.repeatDays,
        startTime: firstDto.startTime,
        endTime: firstDto.endTime,
        status: dto.status
      )
    }
    return TimerAllFetchStatusResponse(
      id: 0,
      title: "",
      focusTypeId: 0,
      repeatCycleCode: "",
      repeatDays: "",
      startTime: "",
      endTime: "",
      status: dto.status
    )
  }
  
  func getTimerStatus(id: Int) async throws -> TimerStatus {
    let userId = try await currentUserId()
    let snapshot = try await FirestoreAsync.getDocument(timerDocRef(userId: userId, timerId: id))
    guard let status = snapshot.data()?["status"] as? String,
          let timerStatus = TimerStatus(rawValue: status) else {
      throw TimerRepositoryError.decodingError
    }
    return timerStatus
  }
  
  func deleteTimer(id: Int) async throws {
    let userId = try await currentUserId()
    try await FirestoreAsync.updateData(timerDocRef(userId: userId, timerId: id), data: [
      "delFlag": "Y",
      "status": TimerStatus.OFF.rawValue,
      "updatedAt": Timestamp(date: Date()),
    ])
  }
  
  func unlockTimer(timerId: String, failReason: String) async throws {
    let userId = try await currentUserId()
    guard let timerIdInt = Int(timerId) else { return }
    let timerRef = timerDocRef(userId: userId, timerId: timerIdInt)
    let snapshot = try await FirestoreAsync.getDocument(timerRef)
    guard let timerDto = Self.timerDto(from: snapshot) else { return }

    try await FirestoreAsync.updateData(timerRef, data: [
      "status": TimerStatus.OFF.rawValue,
      "updatedAt": Timestamp(date: Date()),
    ])

    let historyId = Self.makeId()
    let now = Date()
    let historyRef = historyDocRef(userId: userId, historyId: historyId)
    let focusTitle = StaticValManager.titleDic[timerDto.focusTypeId] ?? ""
    let historyData: [String: Any] = [
      "id": historyId,
      "timerId": timerDto.id,
      "userId": userId,
      "title": timerDto.title,
      "focusTypeId": timerDto.focusTypeId,
      "focusTypeTitle": focusTitle,
      "repeatCycleCode": timerDto.repeatCycleCode.rawValue,
      "repeatDays": timerDto.repeatDays,
      "historyDt": Timestamp(date: now),
      "historyStatus": "FAILED",
      "failReason": failReason,
      "startTime": timerDto.startTime,
      "endTime": timerDto.endTime,
      "hasRetrospect": false,
      "retrospectId": NSNull(),
      "retrospectImmersion": NSNull(),
      "retrospectComment": NSNull(),
      "retrospectSummary": TimerHistoryRepository.makeRetrospectSummary(
        historyDt: now,
        startTime: timerDto.startTime,
        endTime: timerDto.endTime
      ),
      "delFlag": "N",
    ]
    try await FirestoreAsync.setData(historyRef, data: historyData)
  }

  private func timersCollection(userId: String) -> CollectionReference {
    db.collection("users").document(userId).collection("timers")
  }

  private func timerDocRef(userId: String, timerId: Int) -> DocumentReference {
    timersCollection(userId: userId).document(String(timerId))
  }

  private func historyDocRef(userId: String, historyId: Int) -> DocumentReference {
    db.collection("users").document(userId).collection("timerHistories").document(String(historyId))
  }

  private func currentUserId() async throws -> String {
    try await FirebaseAuthManager.shared.ensureUserId()
  }

  private func hasOverlappingRunningTimer(
    userId: String,
    startTime: String,
    endTime: String,
    excludingId: Int?
  ) async throws -> Bool {
    let query = timersCollection(userId: userId)
      .whereField("delFlag", isEqualTo: "N")
      .whereField("status", isEqualTo: TimerStatus.ON.rawValue)
    let snapshot = try await FirestoreAsync.getDocuments(query)
    let segments = Self.timeSegments(startTime: startTime, endTime: endTime)
    for doc in snapshot.documents {
      guard let dto = Self.timerDto(from: doc) else { continue }
      if let excludingId, dto.id == excludingId { continue }
      let otherSegments = Self.timeSegments(startTime: dto.startTime, endTime: dto.endTime)
      if Self.segmentsOverlap(segments, otherSegments) {
        return true
      }
    }
    return false
  }

  private static func timeSegments(startTime: String, endTime: String) -> [(Int, Int)] {
    guard let start = minutes(from: startTime),
          let end = minutes(from: endTime) else {
      return []
    }
    if start == end {
      return [(0, 24 * 60)]
    }
    if start < end {
      return [(start, end)]
    }
    return [(start, 24 * 60), (0, end)]
  }

  private static func segmentsOverlap(_ a: [(Int, Int)], _ b: [(Int, Int)]) -> Bool {
    for (aa, ae) in a {
      for (bs, be) in b {
        if aa <= be && bs <= ae {
          return true
        }
      }
    }
    return false
  }

  private static func minutes(from time: String) -> Int? {
    let parts = time.split(separator: ":").compactMap { Int($0) }
    guard parts.count >= 2 else { return nil }
    return parts[0] * 60 + parts[1]
  }

  private static func isNowWithinRange(startTime: String, endTime: String) -> Bool {
    let now = Date()
    let calendar = Calendar.current
    let nowComp = calendar.dateComponents([.hour, .minute], from: now)
    guard let hour = nowComp.hour, let minute = nowComp.minute else { return false }
    let nowMinutes = hour * 60 + minute
    let segments = timeSegments(startTime: startTime, endTime: endTime)
    for (s, e) in segments {
      if s <= nowMinutes && nowMinutes <= e {
        return true
      }
    }
    return false
  }

  private static func makeId() -> Int {
    let millis = Int(Date().timeIntervalSince1970 * 1000)
    return millis * 1000 + Int.random(in: 0..<1000)
  }

  private static func timerDto(from snapshot: DocumentSnapshot) -> TimerResponseDto? {
    let data = snapshot.data() ?? [:]
    guard
      let id = Self.intValue(from: data["id"]) ?? Int(snapshot.documentID),
      let title = data["title"] as? String,
      let focusTypeId = Self.intValue(from: data["focusTypeId"]),
      let repeatCycleCodeRaw = data["repeatCycleCode"] as? String,
      let repeatCycleCode = RepeatCycleCode(rawValue: repeatCycleCodeRaw),
      let repeatDays = data["repeatDays"] as? String,
      let startTime = data["startTime"] as? String,
      let endTime = data["endTime"] as? String,
      let statusRaw = data["status"] as? String,
      let status = TimerStatus(rawValue: statusRaw)
    else { return nil }

    let timerCodeRaw = data["timerCode"] as? String
    let timerCode = timerCodeRaw.flatMap { TimerCode(rawValue: $0) }

    return TimerResponseDto(
      id: id,
      title: title,
      focusTypeId: focusTypeId,
      repeatCycleCode: repeatCycleCode,
      repeatDays: repeatDays,
      startTime: startTime,
      endTime: endTime,
      status: status,
      timerCode: timerCode
    )
  }

  private static func intValue(from value: Any?) -> Int? {
    if let value = value as? Int {
      return value
    }
    if let value = value as? Int64 {
      return Int(value)
    }
    if let value = value as? NSNumber {
      return value.intValue
    }
    return nil
  }
}
enum FailReason: String {
    case lackOfFocusIntention = "집중 의지가 부족해요"
    case needBreak = "휴식이 필요해요"
    case finishedEarly = "일정이 빨리 끝났어요"
    case emergency = "긴급한 상황이 발생했어요"
    case externalDisturbance = "외부의 방해가 있어요"
    case none = "에러가 발생하였습니다"
    
    var description: String {
        return self.rawValue
    }
}
