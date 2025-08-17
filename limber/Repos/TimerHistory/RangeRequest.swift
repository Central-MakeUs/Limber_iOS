//
//  RangeRequest.swift
//  limber
//
//  Created by 양승완 on 8/11/25.
//

import Foundation


struct RangeRequest: Encodable {
    let userId: String
    let startDate: String
    let endDate: String

  init(userId: String, start: String, end: String) {
        self.userId = userId
    self.startDate = start
    self.endDate = end
    }
}


struct WeekdayActualDto: Decodable {
    let weekdayIndex: Int
    let dayOfWeek: String
    let totalActualMinutes: Int
}

struct WeekdayImmersionDto: Decodable {
    let weekdayIndex: Int
    let dayOfWeek: String
    let totalActualMinutes: Int
    let totalScheduledMinutes: Int
    /// ratio = 실제 / 예정
    let ratio: Double
}

struct TotalActualDto: Decodable {
    let totalMinutes: Int
    /// 사람이 읽기 좋은 "X시간 Y분"
    let label: String
}

struct TotalImmersionDto: Decodable {
    let totalActualMinutes: Int
    let totalScheduledMinutes: Int
    let ratio: Double
}

struct FocusDistributionDto: Decodable {
  let focusTypeId: Int
  let focusTypeName: String
  let totalActualMinutes: Int
}

struct FailReasonCountDto: Decodable {
    let failReason: String
    let count: Int
}
struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T
    let error: String?
}


// MARK: - API 클라이언트
struct TimerHistoryAnalyticsAPI {
  
  private let baseURL: URL = URLManager.baseURL
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.withoutEscapingSlashes]

        let decoder = JSONDecoder()
        self.encoder = encoder
        self.decoder = decoder
    }

    // POST 공통 헬퍼
    private func post<Req: Encodable, Res: Decodable>(
        _ path: String,
        body: Req
    ) async throws -> Res {
        let url = baseURL.appendingPathComponent("/api/timer-histories").appendingPathComponent(path)
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try encoder.encode(body)

        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let code = (resp as? HTTPURLResponse)?.statusCode ?? -1
            let message = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "TimerHistoryAnalyticsAPI",
                          code: code,
                          userInfo: [NSLocalizedDescriptionKey: "HTTP \(code): \(message)"])
        }
        return try decoder.decode(Res.self, from: data)
    }

    // (1) /actual-by-weekday
    func actualByWeekday(_ range: RangeRequest) async throws -> APIResponse<[WeekdayActualDto]> {
      try await post("actual-by-weekday", body: range)
    }

    func immersionByWeekday(_ range: RangeRequest) async throws -> APIResponse<[WeekdayImmersionDto]> {
        try await post("immersion-by-weekday", body: range)
    }

    // (3) /total-actual
    func totalActual(_ range: RangeRequest) async throws -> APIResponse<TotalActualDto> {
        try await post("total-actual", body: range)
    }

    // (4) /total-immersion
    func totalImmersion(_ range: RangeRequest) async throws -> APIResponse<TotalImmersionDto> {
        try await post("total-immersion", body: range)
    }

    // (5) /focus-distribution
    func focusDistribution(_ range: RangeRequest) async throws -> APIResponse<[FocusDistributionDto]> {
        try await post("focus-distribution", body: range)
    }

    // (6) /fail-reasons
    func failReasons(_ range: RangeRequest) async throws -> APIResponse<[FailReasonCountDto]> {
        try await post("fail-reasons", body: range)
    }
}
