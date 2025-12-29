//
//  FocusTypeRequestDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation
import FirebaseFirestore

// MARK: - Protocol
protocol FocusTypeRepositoryProtocol {
  func createFocusType(_ dto: FocusTypeRequestDto) async throws -> FocusTypeResponseDto
  func getFocusTypes(userId: Int) async throws -> [FocusTypeResponseDto]
}

// MARK: - Repository 구현
final class FocusTypeRepository: FocusTypeRepositoryProtocol {
  private let db = Firestore.firestore()

  init() {}
  
  /// 집중유형 생성 (POST /api/focus-types)
  func createFocusType(_ dto: FocusTypeRequestDto) async throws -> FocusTypeResponseDto {
    let focusId = Self.makeId()
    let ref = focusTypesCollection(userId: dto.userId).document(String(focusId))
    let data: [String: Any] = [
      "id": focusId,
      "title": dto.title,
      "userId": dto.userId,
      "defaultFlag": "N",
      "sequence": dto.sequence,
    ]
    try await FirestoreAsync.setData(ref, data: data)
    return FocusTypeResponseDto(
      id: focusId,
      title: dto.title,
      userId: dto.userId,
      defaultFlag: "N",
      sequence: dto.sequence
    )
  }
  
  /// 유저의 집중유형 목록 조회 (GET /api/focus-types/{userId})
  func getFocusTypes(userId: Int) async throws -> [FocusTypeResponseDto] {
    let snapshot = try await FirestoreAsync.getDocuments(focusTypesCollection(userId: userId))
    return snapshot.documents.compactMap { doc in
      let data = doc.data()
      guard
        let id = Self.intValue(from: data["id"]) ?? Int(doc.documentID),
        let title = data["title"] as? String,
        let userId = Self.intValue(from: data["userId"]),
        let defaultFlag = data["defaultFlag"] as? String,
        let sequence = Self.intValue(from: data["sequence"])
      else { return nil }
      return FocusTypeResponseDto(
        id: id,
        title: title,
        userId: userId,
        defaultFlag: defaultFlag,
        sequence: sequence
      )
    }

  }

  private func focusTypesCollection(userId: Int) -> CollectionReference {
    db.collection("users").document(String(userId)).collection("focusTypes")
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
