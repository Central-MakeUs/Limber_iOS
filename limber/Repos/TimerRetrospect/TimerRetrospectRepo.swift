//
//  TimerRetrospectRequestDto 2.swift
//  limber
//
//  Created by 양승완 on 8/11/25.
//


import Foundation
import FirebaseFirestore

protocol TimerRetrospectRepoProtocol {
  func saveRetrospect(_ body: TimerRetrospectRequestDto) async throws -> TimerRetrospectResponseDto?
  func deleteRetrospect(id: Int64) async throws
}

struct TimerRetrospectRepo: TimerRetrospectRepoProtocol {
  private let db = Firestore.firestore()

  init() {}
  /// POST /api/timer-retrospects
  func saveRetrospect(_ body: TimerRetrospectRequestDto) async throws -> TimerRetrospectResponseDto? {
    let userId = body.userId
    let retrospectId = Self.makeId()
    let now = Timestamp(date: Date())
    let retrospectRef = retrospectsCollection(userId: userId).document(String(retrospectId))
    let data: [String: Any] = [
      "id": retrospectId,
      "timerHistoryId": body.timerHistoryId,
      "timerId": body.timerId,
      "userId": body.userId,
      "immersion": body.immersion,
      "comment": body.comment,
      "delFlag": "N",
      "historyDt": now,
    ]
    try await FirestoreAsync.setData(retrospectRef, data: data)

    let historyRef = historyCollection(userId: userId).document(String(body.timerHistoryId))
    try await FirestoreAsync.updateData(historyRef, data: [
      "hasRetrospect": true,
      "retrospectId": retrospectId,
      "retrospectImmersion": body.immersion,
      "retrospectComment": body.comment,
    ])

    return TimerRetrospectResponseDto(
      id: retrospectId,
      timerHistoryId: body.timerHistoryId,
      timerId: body.timerId,
      userId: body.userId,
      immersion: body.immersion,
      comment: body.comment,
      delFlag: "N"
    )
  }
  /// DELETE /api/timer-retrospects/{timerRetrospectId}
  func deleteRetrospect(id: Int64) async throws {
    let userId = try await FirebaseAuthManager.shared.ensureUserId()
    let ref = retrospectsCollection(userId: userId).document(String(id))
    let snapshot = try await FirestoreAsync.getDocument(ref)
    try await FirestoreAsync.updateData(ref, data: [
      "delFlag": "Y",
    ])
    if let historyId = Self.intValue(from: snapshot.data()?["timerHistoryId"]) {
      let historyRef = historyCollection(userId: userId).document(String(historyId))
      try await FirestoreAsync.updateData(historyRef, data: [
        "hasRetrospect": false,
        "retrospectId": NSNull(),
        "retrospectImmersion": NSNull(),
        "retrospectComment": NSNull(),
      ])
    }
  }

  private func retrospectsCollection(userId: String) -> CollectionReference {
    db.collection("users").document(userId).collection("timerRetrospects")
  }

  private func historyCollection(userId: String) -> CollectionReference {
    db.collection("users").document(userId).collection("timerHistories")
  }

  private static func makeId() -> Int {
    let millis = Int(Date().timeIntervalSince1970 * 1000)
    return millis * 1000 + Int.random(in: 0..<1000)
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
