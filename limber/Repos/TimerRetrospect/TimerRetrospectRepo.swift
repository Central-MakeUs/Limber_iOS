//
//  TimerRetrospectRequestDto 2.swift
//  limber
//
//  Created by 양승완 on 8/11/25.
//


import Foundation

// MARK: - Request / Response DTO

struct TimerRetrospectRequestDto: Encodable {
    let userId: String
    let timerHistoryId: Int64
    let timerId: Int64
    let immersion: Int
    let comment: String
}

struct TimerRetrospectResponseDto: Decodable {
    let id: Int64
    let timerHistoryId: Int64
    let timerId: Int64
    let userId: String
    let immersion: Int
    let comment: String
    let delFlag: String
}

// MARK: - API Client

struct TimerRetrospectAPI {
  private let baseURL: URL = .init(string: "http://3.35.146.79:8888")!
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    /// POST /api/timer-retrospects
    func saveRetrospect(_ body: TimerRetrospectRequestDto) async throws -> TimerRetrospectResponseDto {
        let url = baseURL.appendingPathComponent("/api/timer-retrospects")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try encoder.encode(body)

        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw makeHTTPError(resp: resp, data: data)
        }
        return try decoder.decode(TimerRetrospectResponseDto.self, from: data)
    }

    /// DELETE /api/timer-retrospects/{timerRetrospectId}
    func deleteRetrospect(id: Int64) async throws {
        let url = baseURL
            .appendingPathComponent("/api/timer-retrospects")
            .appendingPathComponent(String(id))

        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"

        let (_, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            // 컨트롤러는 204(No Content) 반환 → 2xx면 성공으로 처리
            throw makeHTTPError(resp: resp, data: nil)
        }
    }

    // 간단한 에러 생성 헬퍼
    private func makeHTTPError(resp: URLResponse, data: Data?) -> NSError {
        let code = (resp as? HTTPURLResponse)?.statusCode ?? -1
        let message = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        return NSError(domain: "TimerRetrospectAPI",
                       code: code,
                       userInfo: [NSLocalizedDescriptionKey: "HTTP \(code): \(message)"])
    }
}

// MARK: - 사용 예시
/*
let api = TimerRetrospectAPI(baseURL: URL(string: "https://your.server.com")!)

let req = TimerRetrospectRequestDto(
    userId: "USER_123",
    timerHistoryId: 1001,
    timerId: 777,
    immersion: 85,
    comment: "컨디션 좋았음"
)

do {
    // 저장
    let saved = try await api.saveRetrospect(req)
    print("saved id =", saved.id)

    // 삭제
    try await api.deleteRetrospect(id: saved.id)
    print("deleted")
} catch {
    print("API error:", error)
}
*/
