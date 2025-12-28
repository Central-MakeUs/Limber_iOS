//
//  HistoryStatus.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation
import FirebaseCore
import FirebaseFirestore

protocol TimerHistoryRepositoryProtocol {
  func getLatestHistory(userId: String, timerId: String) async throws -> TimerHistoryResponseDto?
  func getHistoriesAll(_ dto: TimerHistorySearchDto) async throws -> [TimerHistoryResponseDto]
  func getHistoriesWeekly(_ dto: TimerHistorySearchDto) async throws -> [TimerWeeklyHistoryResponseDto]
  
  //POST
  func actualByWeekday(_ req: RangeRequest) async throws -> [WeekdayActualDto]
  func immersionByWeekday(_ req: RangeRequest) async throws -> [WeekdayImmersionDto]
  func totalActual(_ req: RangeRequest) async throws -> TotalActualDto
  func totalImmersion(_ req: RangeRequest) async throws -> TotalImmersionDto
  func focusDistribution(_ req: RangeRequest) async throws -> [FocusDistributionDto]
  func failReasons(_ req: RangeRequest) async throws -> [FailReasonCountDto]

}
final class TimerHistoryRepository: TimerHistoryRepositoryProtocol {
  private let db = Firestore.firestore()
  private let isoFormatter = ISO8601DateFormatter()
  private let historyFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
  }()
  private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  init() {}
  
  func getLatestHistory(userId: String, timerId: String) async throws -> TimerHistoryResponseDto? {
    guard let timerIdInt = Int(timerId) else { return nil }
    let query = historyCollection(userId: userId)
      .whereField("timerId", isEqualTo: timerIdInt)
    let snapshot = try await FirestoreAsync.getDocuments(query)
    let histories = snapshot.documents.compactMap { Self.historyDto(from: $0) }
    return sortByHistoryDateDesc(histories).first
  }
  
  func getHistoriesAll(_ dto: TimerHistorySearchDto) async throws -> [TimerHistoryResponseDto] {
    var query: Query = historyCollection(userId: dto.userId)
    if dto.onlyIncompleteRetrospect {
      query = query.whereField("hasRetrospect", isEqualTo: false)
    }
    let snapshot = try await FirestoreAsync.getDocuments(query)
    let histories = snapshot.documents.compactMap { Self.historyDto(from: $0) }
    return sortByHistoryDateDesc(histories)
  }
  
  func getHistoriesWeekly(_ dto: TimerHistorySearchDto) async throws -> [TimerWeeklyHistoryResponseDto] {
    let histories = try await getHistoriesAll(dto)
    var grouped: [Date: [TimerHistoryResponseDto]] = [:]
    let calendar = Calendar(identifier: .iso8601)

    for history in histories {
      guard let date = isoDate(from: history.historyDt) else { continue }
      let weekStart = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
      grouped[weekStart, default: []].append(history)
    }
    let sortedKeys = grouped.keys.sorted(by: >)
    return sortedKeys.map { start in
      let end = Calendar(identifier: .iso8601).date(byAdding: .day, value: 6, to: start) ?? start
      return TimerWeeklyHistoryResponseDto(
        weekStart: dayFormatter.string(from: start),
        weekEnd: dayFormatter.string(from: end),
        items: grouped[start] ?? []
      )
    }
  }
  
  // (1) /actual-by-weekday
  func actualByWeekday(_ req: RangeRequest) async throws -> [WeekdayActualDto] {
    let histories = try await historiesInActualRange(req)
    var actual = Array(repeating: 0, count: 7)
    for h in histories {
      guard let actualStart = actualStartDate(for: h),
            let actualEnd = isoDate(from: h.historyDt) else { continue }
      let minutes = max(0, Int(actualEnd.timeIntervalSince(actualStart) / 60))
      if minutes == 0 { continue }
      let idx = weekdayIndex(for: actualStart)
      actual[idx] += minutes
    }
    return (0..<7).map { WeekdayActualDto(weekdayIndex: $0, dayOfWeek: weekdayName(from: $0), totalActualMinutes: actual[$0]) }
  }
// (2) /immersion-by-weekday
  func immersionByWeekday(_ req: RangeRequest) async throws -> [WeekdayImmersionDto] {
    let histories = try await historiesInActualRange(req)
    var act = Array(repeating: 0, count: 7)
    var sched = Array(repeating: 0, count: 7)
    for h in histories {
      guard let actualStart = actualStartDate(for: h),
            let actualEnd = isoDate(from: h.historyDt) else { continue }
      let a = max(0, Int(actualEnd.timeIntervalSince(actualStart) / 60))
      let s = scheduledMinutes(startTime: h.startTime, endTime: h.endTime)
      if a == 0 && s == 0 { continue }
      let idx = weekdayIndex(for: actualStart)
      if a > 0 { act[idx] += a }
      if s > 0 { sched[idx] += s }
    }
    return (0..<7).map { idx in
      let ratio = sched[idx] == 0 ? 0.0 : Double(act[idx]) / Double(sched[idx])
      return WeekdayImmersionDto(
        weekdayIndex: idx,
        dayOfWeek: weekdayName(from: idx),
        totalActualMinutes: act[idx],
        totalScheduledMinutes: sched[idx],
        ratio: TimerHistoryRepository.round2(ratio)
      )
    }
  }

  // (3) /total-actual
  func totalActual(_ req: RangeRequest) async throws -> TotalActualDto {
    let histories = try await historiesInActualRange(req)
    let total = histories.compactMap { h -> Int? in
      guard let actualStart = actualStartDate(for: h),
            let actualEnd = isoDate(from: h.historyDt) else { return nil }
      let minutes = max(0, Int(actualEnd.timeIntervalSince(actualStart) / 60))
      return minutes > 0 ? minutes : nil
    }.reduce(0, +)
    return TotalActualDto(totalMinutes: total, label: TimeManager.shared.minutesToHourMinuteString(total))
  }

  // (4) /total-immersion
  func totalImmersion(_ req: RangeRequest) async throws -> TotalImmersionDto {
    let histories = try await historiesInActualRange(req)
    var totalAct = 0
    var totalSched = 0
    for h in histories {
      guard let actualStart = actualStartDate(for: h),
            let actualEnd = isoDate(from: h.historyDt) else { continue }
      let a = max(0, Int(actualEnd.timeIntervalSince(actualStart) / 60))
      let s = scheduledMinutes(startTime: h.startTime, endTime: h.endTime)
      if a > 0 { totalAct += a }
      if s > 0 { totalSched += s }
    }
    let ratio = totalSched == 0 ? 0.0 : Double(totalAct) / Double(totalSched)
    return TotalImmersionDto(totalActualMinutes: totalAct, totalScheduledMinutes: totalSched, ratio: TimerHistoryRepository.round2(ratio))
  }

  // (5) /focus-distribution
  func focusDistribution(_ req: RangeRequest) async throws -> [FocusDistributionDto] {
    let histories = try await historiesInActualRange(req)
    var acc: [Int: (name: String, total: Int)] = [:]
    for h in histories {
      guard let actualStart = actualStartDate(for: h),
            let actualEnd = isoDate(from: h.historyDt) else { continue }
      let minutes = max(0, Int(actualEnd.timeIntervalSince(actualStart) / 60))
      if minutes <= 0 { continue }
      let name = h.focusTypeTitle
      if let existing = acc[h.focusTypeId] {
        acc[h.focusTypeId] = (existing.name, existing.total + minutes)
      } else {
        acc[h.focusTypeId] = (name, minutes)
      }
    }
    return acc.map {
      FocusDistributionDto(focusTypeId: $0.key, focusTypeName: $0.value.name, totalActualMinutes: $0.value.total)
    }.sorted { $0.totalActualMinutes > $1.totalActualMinutes }
  }

  // (6) /fail-reasons
  func failReasons(_ req: RangeRequest) async throws -> [FailReasonCountDto] {
    guard let range = dateRange(from: req) else { return [] }
    let query = historyCollection(userId: req.userId)
      .whereField("historyDt", isGreaterThanOrEqualTo: range.start)
      .whereField("historyDt", isLessThanOrEqualTo: range.end)
    let snapshot = try await FirestoreAsync.getDocuments(query)
    var counts: [String: Int] = [:]
    for doc in snapshot.documents {
      guard let history = Self.historyDto(from: doc),
            history.historyStatus == "FAILED" else { continue }
      let reason = history.failReason ?? "NONE"
      counts[reason, default: 0] += 1
    }
    return counts.map { FailReasonCountDto(failReason: $0.key, count: $0.value) }
      .sorted { $0.failReason < $1.failReason }
  }

  func flushPendingHistories() async throws {
    let pending = TimerSharedManager.shared.loadPendingHistories()
    guard !pending.isEmpty else { return }
    let fallbackUserId = try await FirebaseAuthManager.shared.ensureUserId()
    for item in pending {
      let historyId = Self.makeId()
      let historyDt = Date(timeIntervalSince1970: item.historyTimestamp)
      let focusTitle = item.focusTypeTitle ?? (StaticValManager.titleDic[item.focusTypeId] ?? "")
      let userId = item.userId.isEmpty ? fallbackUserId : item.userId
      if userId.isEmpty { continue }
      let data: [String: Any] = [
        "id": historyId,
        "timerId": item.timerId,
        "userId": userId,
        "title": item.title,
        "focusTypeId": item.focusTypeId,
        "focusTypeTitle": focusTitle,
        "repeatCycleCode": item.repeatCycleCode,
        "repeatDays": item.repeatDays,
        "historyDt": Timestamp(date: historyDt),
        "historyStatus": item.historyStatus,
        "failReason": item.failReason as Any,
        "startTime": item.startTime,
        "endTime": item.endTime,
        "hasRetrospect": false,
        "retrospectId": NSNull(),
        "retrospectImmersion": NSNull(),
        "retrospectComment": NSNull(),
        "retrospectSummary": Self.makeRetrospectSummary(
          historyDt: historyDt,
          startTime: item.startTime,
          endTime: item.endTime
        ),
        "delFlag": "N",
      ]
      let ref = historyCollection(userId: userId).document(String(historyId))
      try await FirestoreAsync.setData(ref, data: data)
    }
    TimerSharedManager.shared.clearPendingHistories()
  }
  
  static func makeRetrospectSummary(historyDt: Date, startTime: String, endTime: String) -> String {
    let zone = TimeZone(identifier: "Asia/Seoul") ?? .current
    var calendar = Calendar.current
    calendar.timeZone = zone
    let baseDate = calendar.startOfDay(for: historyDt)
    let today = calendar.startOfDay(for: Date())
    let daysDiff = calendar.dateComponents([.day], from: baseDate, to: today).day ?? 0
    let dayPart = daysDiff == 0 ? "오늘" : "\(daysDiff)일 전"

    guard let start = combine(date: baseDate, time: startTime, zone: zone),
          let end = combine(date: baseDate, time: endTime, zone: zone) else {
      return ""
    }
    var actualEnd = end
    if actualEnd < start {
      actualEnd = calendar.date(byAdding: .day, value: 1, to: actualEnd) ?? actualEnd
    }
    let minutes = Int(actualEnd.timeIntervalSince(start) / 60)
    let hours = minutes / 60
    let mins = minutes % 60
    var timePart = ""
    if hours > 0 { timePart += "\(hours)시간 " }
    timePart += "\(mins)분"
    return "\(dayPart), \(timePart)"
  }

  private func historyCollection(userId: String) -> CollectionReference {
    db.collection("users").document(userId).collection("timerHistories")
  }

  private func historiesInActualRange(_ req: RangeRequest) async throws -> [TimerHistoryResponseDto] {
    guard let range = dateRange(from: req) else { return [] }
    let queryEnd = Calendar.current.date(byAdding: .day, value: 1, to: range.end) ?? range.end
    let query = historyCollection(userId: req.userId)
      .whereField("historyDt", isGreaterThanOrEqualTo: range.start)
      .whereField("historyDt", isLessThanOrEqualTo: queryEnd)
    let snapshot = try await FirestoreAsync.getDocuments(query)
    let histories = snapshot.documents.compactMap { Self.historyDto(from: $0) }
    return histories.filter { history in
      guard let actualStart = actualStartDate(for: history) else { return false }
      return actualStart >= range.start && actualStart <= range.end
    }
  }

  private func dateRange(from req: RangeRequest) -> (start: Date, end: Date)? {
    let formatter = dayFormatter
    guard let startDate = formatter.date(from: req.startDate),
          let endDate = formatter.date(from: req.endDate) else { return nil }
    let end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
    return (startDate, end)
  }

  private func isoDate(from iso: String) -> Date? {
    if let date = historyFormatter.date(from: iso) {
      return date
    }
    isoFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
    return isoFormatter.date(from: iso)
  }

  private func actualStartDate(for history: TimerHistoryResponseDto) -> Date? {
    guard let endDate = isoDate(from: history.historyDt) else { return nil }
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    let baseDate = calendar.startOfDay(for: endDate)
    let startMinutes = Self.minutes(from: history.startTime) ?? 0
    let endMinutes = calendar.component(.hour, from: endDate) * 60 + calendar.component(.minute, from: endDate)
    var startDate = TimerHistoryRepository.combine(date: baseDate, time: history.startTime, zone: calendar.timeZone) ?? endDate
    if endMinutes < startMinutes {
      startDate = calendar.date(byAdding: .day, value: -1, to: startDate) ?? startDate
    }
    return startDate
  }

  private static func minutes(from time: String) -> Int? {
    let parts = time.split(separator: ":").compactMap { Int($0) }
    guard parts.count >= 2 else { return nil }
    return parts[0] * 60 + parts[1]
  }

  private func scheduledMinutes(startTime: String, endTime: String) -> Int {
    let start = Self.minutes(from: startTime) ?? 0
    let end = Self.minutes(from: endTime) ?? 0
    if start == end { return 0 }
    if end < start { return (24 * 60 - start) + end }
    return end - start
  }

  private func weekdayIndex(for date: Date) -> Int {
    let weekday = Calendar.current.component(.weekday, from: date)
    return max(0, weekday - 1)
  }

  private func weekdayName(from index: Int) -> String {
    return switch index {
    case 0: "SUNDAY"
    case 1: "MONDAY"
    case 2: "TUESDAY"
    case 3: "WEDNESDAY"
    case 4: "THURSDAY"
    case 5: "FRIDAY"
    case 6: "SATURDAY"
    default: "SUNDAY"
    }
  }

  private static func round2(_ v: Double) -> Double {
    return (v * 100).rounded() / 100
  }

  private static func makeId() -> Int {
    let millis = Int(Date().timeIntervalSince1970 * 1000)
    return millis * 1000 + Int.random(in: 0..<1000)
  }

  private static func historyDto(from snapshot: DocumentSnapshot) -> TimerHistoryResponseDto? {
    let data = snapshot.data() ?? [:]
    if let delFlag = data["delFlag"] as? String, delFlag != "N" {
      return nil
    }
    guard
      let id = Self.intValue(from: data["id"]) ?? Int(snapshot.documentID),
      let timerId = Self.intValue(from: data["timerId"]),
      let userId = data["userId"] as? String,
      let title = data["title"] as? String,
      let focusTypeId = Self.intValue(from: data["focusTypeId"]),
      let repeatCycleCode = data["repeatCycleCode"] as? String,
      let repeatDays = data["repeatDays"] as? String,
      let historyStatus = data["historyStatus"] as? String,
      let startTime = data["startTime"] as? String,
      let endTime = data["endTime"] as? String
    else { return nil }

    let historyDt = (data["historyDt"] as? Timestamp)?.dateValue() ?? Date()
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let historyDtStr = formatter.string(from: historyDt)
    let focusTitle = data["focusTypeTitle"] as? String ?? (StaticValManager.titleDic[focusTypeId] ?? "")
    let retrospectSummary = data["retrospectSummary"] as? String
      ?? makeRetrospectSummary(historyDt: historyDt, startTime: startTime, endTime: endTime)

    return TimerHistoryResponseDto(
      id: id,
      timerId: timerId,
      userId: userId,
      title: title,
      focusTypeId: focusTypeId,
      repeatCycleCode: repeatCycleCode,
      repeatDays: repeatDays,
      historyDt: historyDtStr,
      historyStatus: historyStatus,
      failReason: data["failReason"] as? String,
      startTime: startTime,
      endTime: endTime,
      hasRetrospect: data["hasRetrospect"] as? Bool ?? false,
      retrospectId: Self.intValue(from: data["retrospectId"]),
      retrospectImmersion: Self.intValue(from: data["retrospectImmersion"]),
      retrospectComment: data["retrospectComment"] as? String,
      focusTypeTitle: focusTitle,
      retrospectSummary: retrospectSummary
    )
  }

  private func sortByHistoryDateDesc(_ histories: [TimerHistoryResponseDto]) -> [TimerHistoryResponseDto] {
    histories.sorted {
      (isoDate(from: $0.historyDt) ?? .distantPast) > (isoDate(from: $1.historyDt) ?? .distantPast)
    }
  }

  private static func combine(date: Date, time: String, zone: TimeZone) -> Date? {
    let parts = time.split(separator: ":").compactMap { Int($0) }
    guard parts.count >= 2 else { return nil }
    var cal = Calendar.current
    cal.timeZone = zone
    return cal.date(bySettingHour: parts[0], minute: parts[1], second: 0, of: date)
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
