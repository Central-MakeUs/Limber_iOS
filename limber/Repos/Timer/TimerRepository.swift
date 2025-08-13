//
//  TimerRepository.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation
protocol TimerRepositoryProtocol {
  func createTimer(_ dto: TimerRequestDto) async throws -> TimerResponseDto
  func getUserTimers(userId: String) async throws -> [TimerResponseDto]
  func getTimer(by id: Int) async throws -> TimerResponseDto
  func updateTimerStatus(id: Int, dto: TimerStatusUpdateDto) async throws -> TimerResponseDto
  func getTimerStatus(id: Int) async throws -> TimerStatus
  func deleteTimer(id: Int) async throws
}

final class TimerRepository: TimerRepositoryProtocol {
  private let baseURL = URLManager.baseURL.appendingPathComponent("/api/timers")
  private let session: URLSession
  private let jsonDecoder: JSONDecoder
  private let jsonEncoder: JSONEncoder
  
  init(session: URLSession = .shared) {
    self.session = session
    
    jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .iso8601
    
    jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .iso8601
  }
  
  func createTimer(_ dto: TimerRequestDto) async throws -> TimerResponseDto {
    let url = baseURL
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try jsonEncoder.encode(dto)
    
    let (data, response) = try await session.data(for: request)
    try validate(response: response)
    let timerResponse = try jsonDecoder.decode(TimerOnceDecoder.self, from: data)
    return timerResponse.data
    
  }
  
  func getUserTimers(userId: String) async throws -> [TimerResponseDto] {
    let url = baseURL.appendingPathComponent("/user/\(userId)")
    let (data, response) = try await session.data(from: url)
    
    try validate(response: response)
    let timerResponse = try jsonDecoder.decode(TimerArrayDecoder.self, from: data)
    
    return timerResponse.data
  }
  
  func getTimer(by id: Int) async throws -> TimerResponseDto {
    let url = baseURL.appendingPathComponent("/\(id)")
    let (data, response) = try await session.data(from: url)
    try validate(response: response)
    let timerResponse = try jsonDecoder.decode(TimerOnceDecoder.self, from: data)
    return timerResponse.data
  }
  
  func updateTimerStatus(id: Int, dto: TimerStatusUpdateDto) async throws -> TimerResponseDto {
    let url = baseURL.appendingPathComponent("/\(id)/status")
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try jsonEncoder.encode(dto)
    
    let (data, response) = try await session.data(for: request)
    try validate(response: response)
    let timerResponse = try jsonDecoder.decode(TimerOnceDecoder.self, from: data)
    
    
    return timerResponse.data
  }
  
  func getTimerStatus(id: Int) async throws -> TimerStatus {
    let url = baseURL.appendingPathComponent("/\(id)/status")
    let (data, response) = try await session.data(from: url)
    try validate(response: response)
    return try jsonDecoder.decode(TimerStatus.self, from: data)
  }
  
  func deleteTimer(id: Int) async throws {
    let url = baseURL.appendingPathComponent("/\(id)")
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    
    let (_, response) = try await session.data(for: request)
    try validate(response: response)
  }
  
  // 공통 응답 코드 검증
  private func validate(response: URLResponse) throws {
    guard let http = response as? HTTPURLResponse else { return }
    guard 200..<300 ~= http.statusCode else {
      throw TimerRepositoryError.httpError(code: http.statusCode)
    }
  }
}
