//
//  TimerRetrospectRequestDto 2.swift
//  limber
//
//  Created by 양승완 on 8/11/25.
//


import Foundation

protocol TimerRetrospectRepoProtocol {
  func saveRetrospect(_ body: TimerRetrospectRequestDto) async throws -> TimerRetrospectResponseDto?
  func deleteRetrospect(id: Int64) async throws
}

struct TimerRetrospectRepo: TimerRetrospectRepoProtocol {
  private let baseURL = "/api/timer-retrospects"
  private let networkManager: NetworkManagerP

  init(networkManager: NetworkManagerP) {
    self.networkManager = networkManager
  }
  /// POST /api/timer-retrospects
  func saveRetrospect(_ body: TimerRetrospectRequestDto) async throws -> TimerRetrospectResponseDto? {
    try await networkManager.requestValidated(.init(path: baseURL, method: .POST, query: nil, body: nil))
  }
  /// DELETE /api/timer-retrospects/{timerRetrospectId}
  func deleteRetrospect(id: Int64) async throws {
    _ = try await networkManager.request(.init(path: baseURL + "\(String(id))", method: .DELETE, query: nil, body: nil))
  }

}

