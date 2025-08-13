//
//  HistoryStatus.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation

protocol TimerHistoryRepositoryProtocol {
    /// 사용자별 타이머 히스토리 조회
    func getHistoriesByUserId(_ userId: Int) async throws -> [TimerHistoryResponseDto]
}
final class TimerHistoryRepository: TimerHistoryRepositoryProtocol {
  private let baseURL = URLManager.baseURL.appendingPathComponent("/api/timer-histories")
    private let session: URLSession
    private let jsonDecoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.jsonDecoder = JSONDecoder()
        // LocalDateTime 디코딩이 필요하다면 dateDecodingStrategy 설정
        // 예: jsonDecoder.dateDecodingStrategy = .formatted(yourDateFormatter)
    }

    func getHistoriesByUserId(_ userId: Int) async throws -> [TimerHistoryResponseDto] {
        let url = baseURL
            .appendingPathComponent("user")
            .appendingPathComponent("\(userId)")
        let (data, response) = try await session.data(from: url)
        try validate(response: response)
        return try jsonDecoder.decode([TimerHistoryResponseDto].self, from: data)
    }

    /// 공통 HTTP 응답 검증 (200–299 이외는 오류 던짐)
    private func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
    }
}
