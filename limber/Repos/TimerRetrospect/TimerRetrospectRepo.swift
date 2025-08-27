//
//  TimerRetrospectRequestDto 2.swift
//  limber
//
//  Created by 양승완 on 8/11/25.
//


import Foundation





struct TimerRetrospectAPI {
  private let baseURL: URL = URLManager.baseURL
  private let session: URLSession
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  /// POST /api/timer-retrospects
  func saveRetrospect(_ body: TimerRetrospectRequestDto) async throws -> TimerRetrospectResponseDto? {
    let url = baseURL.appendingPathComponent("/api/timer-retrospects")
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = try encoder.encode(body)
    
    let (data, resp) = try await session.data(for: req)
    guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
      throw makeHTTPError(resp: resp, data: data)
    }
    return try decoder.decode(TimerRetrospectResponse.self, from: data).data.first
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

