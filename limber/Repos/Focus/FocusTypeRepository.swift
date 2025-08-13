//
//  FocusTypeRequestDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation

// MARK: - Protocol
protocol FocusTypeRepositoryProtocol {
  /// 집중유형 등록
  func createFocusType(_ dto: FocusTypeRequestDto) async throws -> FocusTypeResponseDto
  /// 유저의 집중유형 목록 조회
  func getFocusTypes(userId: Int) async throws -> [FocusTypeResponseDto]
}

// MARK: - Repository 구현
final class FocusTypeRepository: FocusTypeRepositoryProtocol {
  private let baseURL = URLManager.baseURL.appendingPathComponent("/api/focus-types")
  private let session: URLSession
  private let jsonDecoder: JSONDecoder
  private let jsonEncoder: JSONEncoder
  
  init(session: URLSession = .shared) {
    self.session = session
    self.jsonDecoder = JSONDecoder()
    self.jsonEncoder = JSONEncoder()
  }
  
  /// 집중유형 생성 (POST /api/focus-types)
  func createFocusType(_ dto: FocusTypeRequestDto) async throws -> FocusTypeResponseDto {
    var request = URLRequest(url: baseURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try jsonEncoder.encode(dto)
    
    let (data, response) = try await session.data(for: request)
    try validate(response: response)
    return try jsonDecoder.decode(FocusTypeResponseDto.self, from: data)
  }
  
  /// 유저의 집중유형 목록 조회 (GET /api/focus-types/{userId})
  func getFocusTypes(userId: Int) async throws -> [FocusTypeResponseDto] {
    let url = baseURL.appendingPathComponent("\(userId)")
    let (data, response) = try await session.data(from: url)
    try validate(response: response)
    return try jsonDecoder.decode([FocusTypeResponseDto].self, from: data)
  }
  
  /// 공통 HTTP 응답 검증 (200–299 아니면 오류 던짐)
  private func validate(response: URLResponse) throws {
    guard let http = response as? HTTPURLResponse,
          200..<300 ~= http.statusCode else {
      throw URLError(.badServerResponse)
    }
  }
}
