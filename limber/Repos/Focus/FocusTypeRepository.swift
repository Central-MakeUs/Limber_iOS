//
//  FocusTypeRequestDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation

// MARK: - Protocol
protocol FocusTypeRepositoryProtocol {
  func createFocusType(_ dto: FocusTypeRequestDto) async throws -> FocusTypeResponseDto
  func getFocusTypes(userId: Int) async throws -> [FocusTypeResponseDto]
}

// MARK: - Repository 구현
final class FocusTypeRepository: FocusTypeRepositoryProtocol {
  private let baseURL = "/api/focus-types"
  private let networkManager: NetworkManagerP
  
  init(networkManager: NetworkManagerP) {
    self.networkManager = networkManager
  }
  
  /// 집중유형 생성 (POST /api/focus-types)
  func createFocusType(_ dto: FocusTypeRequestDto) async throws -> FocusTypeResponseDto {
    try await networkManager.requestValidated(.init(path: baseURL, method: .POST, query: nil, body: nil))
  }
  
  /// 유저의 집중유형 목록 조회 (GET /api/focus-types/{userId})
  func getFocusTypes(userId: Int) async throws -> [FocusTypeResponseDto] {
    try await networkManager.requestValidated(.init(path: baseURL + "\(userId)", method: .GET, query: nil, body: nil))

  }

}
