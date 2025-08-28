//
//  HistoryStatus.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation
protocol TimerHistoryRepositoryProtocol {
  func getLatestHistory(userId: String, timerId: String) async throws -> TimerHistoryResponseDto?
  func getHistoriesAll(_ dto: TimerHistorySearchDto) async throws -> [TimerHistoryResponseDto]
  func getHistoriesWeekly(_ dto: TimerHistorySearchDto) async throws -> [TimerWeeklyHistoryResponseDto]
  
  //POST
  func actualByWeekday(_ req: RangeRequest) async throws -> [WeekdayActualDto]
  func immersionByWeekday(_ req: RangeRequest) async throws -> [WeekdayImmersionDto]
  func totalActual(_ req: RangeRequest) async throws -> TotalActualDto
  func totalImmersion(_ req: RangeRequest) async throws -> TotalImmersionDto
  func focusDistribution(_ req: RangeRequest) async throws -> [FocusDistributionDto]
  func failReasons(_ req: RangeRequest) async throws -> [FailReasonCountDto]

}
final class TimerHistoryRepository: TimerHistoryRepositoryProtocol {
  private let baseURL = "/api/timer-histories"
  private let networkManager: NetworkManagerP
  
  init(networkManager: NetworkManagerP) {
    self.networkManager = networkManager
  }
  
  func getLatestHistory(userId: String, timerId: String) async throws -> TimerHistoryResponseDto? {
    try await networkManager.requestValidated(.init(path: baseURL + "/latest-id", method: .GET, query: [
      URLQueryItem(name: "userId", value: userId),
      URLQueryItem(name: "timerId", value: timerId),
    ], body: nil))
    
  }
  
  func getHistoriesAll(_ dto: TimerHistorySearchDto) async throws -> [TimerHistoryResponseDto] {
    try await networkManager.requestValidated(.init(path: baseURL + "/search", method: .GET, query: [
      URLQueryItem(name: "userId", value: dto.userId),
      URLQueryItem(name: "searchRange", value: dto.searchRange),
      URLQueryItem(
        name: "onlyIncompleteRetrospect",
        value: dto.onlyIncompleteRetrospect ? "true" : "false"
      ),
    ], body: nil))
    
  }
  
  func getHistoriesWeekly(_ dto: TimerHistorySearchDto) async throws -> [TimerWeeklyHistoryResponseDto] {
    
    try await networkManager.requestValidated(.init(path: baseURL + "/search", method: .GET, query: [
      URLQueryItem(name: "userId", value: dto.userId),
      URLQueryItem(name: "searchRange", value: dto.searchRange),
      URLQueryItem(
        name: "onlyIncompleteRetrospect",
        value: dto.onlyIncompleteRetrospect ? "true" : "false"
      ),
    ], body: nil))
    
  }
  
  // (1) /actual-by-weekday
  func actualByWeekday(_ req: RangeRequest) async throws -> [WeekdayActualDto] {
    try await networkManager.requestValidated(.init(path: baseURL + "/actual-by-weekday", method: .POST, query: nil, body: req))
  }
// (2) /immersion-by-weekday
  func immersionByWeekday(_ req: RangeRequest) async throws -> [WeekdayImmersionDto] {
    try await networkManager.requestValidated(.init(path: baseURL + "/immersion-by-weekday", method: .POST, query: nil, body: req))
  }

  // (3) /total-actual
  func totalActual(_ req: RangeRequest) async throws -> TotalActualDto {
    try await networkManager.requestValidated(.init(path: baseURL + "/total-actual", method: .POST, query: nil, body: req))
  }

  // (4) /total-immersion
  func totalImmersion(_ req: RangeRequest) async throws -> TotalImmersionDto {
    try await networkManager.requestValidated(.init(path: baseURL + "/total-immersion", method: .POST, query: nil, body: req))
  }

  // (5) /focus-distribution
  func focusDistribution(_ req: RangeRequest) async throws -> [FocusDistributionDto] {
    try await networkManager.requestValidated(.init(path: baseURL + "/focus-distribution", method: .POST, query: nil, body: req))
  }

  // (6) /fail-reasons
  func failReasons(_ req: RangeRequest) async throws -> [FailReasonCountDto] {
    try await networkManager.requestValidated(.init(path: baseURL + "/fail-reasons", method: .POST, query: nil, body: req))
  }
  
}
