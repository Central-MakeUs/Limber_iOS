//
//  RangeRequest.swift
//  limber
//
//  Created by 양승완 on 8/11/25.
//

import Foundation


// MARK: - 공통 RangeRequest (요청 바디)
struct RangeRequest: Encodable {
    let userId: String
    /// 예: "2025-08-01T00:00:00"
    let startDate: String
    /// 예: "2025-08-11T23:59:59"
    let endDate: String

    // 편의 이니셜라이저 (Date → 문자열 포맷 변환)
    init(userId: String, start: Date, end: Date, formatter: DateFormatter = .yyyyMMddTHHmmssKST) {
        self.userId = userId
        self.startDate = formatter.string(from: start)
        self.endDate = formatter.string(from: end)
    }
}

// 서버가 LocalDateTime 문자열을 받는다고 가정하여 KST 기준 포맷 제공
extension DateFormatter {
    /// "yyyy-MM-dd'T'HH:mm:ss" (KST 고정)
    static let yyyyMMddTHHmmssKST: DateFormatter = {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ko_KR")
        df.timeZone = TimeZone(identifier: "Asia/Seoul")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df
    }()
}

// MARK: - 응답 DTO들 (Decodable)

// (1) 요일별 총 실험 시간
struct WeekdayActualDto: Decodable {
    /// 일:0 ~ 토:6
    let weekdayIndex: Int
    /// 예: "SUNDAY", "MONDAY" (서버 DayOfWeek 문자열 가정)
    let dayOfWeek: String
    /// 해당 요일의 실제 실험 시간(분)
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
    let repeatCycleCode: String
    let totalActualMinutes: Int
}

struct FailReasonCountDto: Decodable {
    let failReason: String
    let count: Int
}

// MARK: - API 클라이언트
struct TimerHistoryAnalyticsAPI {
    private let baseURL: URL
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(baseURL: URL,
         session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session

        let encoder = JSONEncoder()
        // 서버가 문자열 날짜를 받으므로 Date 직접 인코딩은 쓰지 않지만 기본 제공
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
    func actualByWeekday(_ range: RangeRequest) async throws -> [WeekdayActualDto] {
        try await post("actual-by-weekday", body: range)
    }

    // (2) /immersion-by-weekday
    func immersionByWeekday(_ range: RangeRequest) async throws -> [WeekdayImmersionDto] {
        try await post("immersion-by-weekday", body: range)
    }

    // (3) /total-actual
    func totalActual(_ range: RangeRequest) async throws -> TotalActualDto {
        try await post("total-actual", body: range)
    }

    // (4) /total-immersion
    func totalImmersion(_ range: RangeRequest) async throws -> TotalImmersionDto {
        try await post("total-immersion", body: range)
    }

    // (5) /focus-distribution
    func focusDistribution(_ range: RangeRequest) async throws -> [FocusDistributionDto] {
        try await post("focus-distribution", body: range)
    }

    // (6) /fail-reasons
    func failReasons(_ range: RangeRequest) async throws -> [FailReasonCountDto] {
        try await post("fail-reasons", body: range)
    }
}
