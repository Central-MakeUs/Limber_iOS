//
//  TimerRepository.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation
//TODO: 동작 테스트
protocol TimerRepositoryProtocol {
  func createTimer(_ dto: TimerRequestDto) async throws -> TimerResponseDto
  func getUserTimers(userId: String) async throws -> [TimerResponseDto]
  func getTimer(by id: Int) async throws -> TimerResponseDto
  func getFetchAll(dto: TimerAllFetchStatusRequest) async throws -> TimerAllFetchStatusResponse
  func updateTimerStatus(id: Int, dto: TimerStatusUpdateDto) async throws -> TimerResponseDto
  func getTimerStatus(id: Int) async throws -> TimerStatus
  func deleteTimer(id: Int) async throws
  func unlockTimer(timerId: String, failReason: String) async throws
}
typealias TimerResponseList = [TimerResponseDto]

final class TimerRepository: TimerRepositoryProtocol {
  private let networkManager: NetworkManagerP
  private let timerBaseURL = "/api/timers"

  
  init(networkManager: NetworkManagerP) {
    self.networkManager = networkManager
  }
  
  
  func createTimer(_ dto: TimerRequestDto) async throws -> TimerResponseDto {
    try await networkManager.requestValidated(.init(path: self.timerBaseURL, method: .POST, query: nil, body: dto))
  }
  
  func getUserTimers(userId: String) async throws -> [TimerResponseDto] {
    let response: [TimerResponseDto] = try await networkManager.requestValidated(
        .init(path: "/api/timer-histories/user/\(userId)", method: .GET, query: nil, body: nil)
    )
    return response
  }
  
  func getTimer(by id: Int) async throws -> TimerResponseDto {
    try await networkManager.requestValidated(.init(path: self.timerBaseURL + "/\(id)", method: .GET, query: nil, body: nil))
  }
  
  func updateTimerStatus(id: Int, dto: TimerStatusUpdateDto) async throws -> TimerResponseDto {
    try await networkManager.requestValidated(.init(path: self.timerBaseURL + "/\(id)/status", method: .PATCH, query: nil, body: dto))
  }

  func getFetchAll(dto: TimerAllFetchStatusRequest) async throws -> TimerAllFetchStatusResponse {
    try await networkManager.requestValidated(.init(path: self.timerBaseURL + "/status", method: .PATCH, query: nil, body: dto))
  }
  
  func getTimerStatus(id: Int) async throws -> TimerStatus {
    try await networkManager.requestValidated(.init(path: self.timerBaseURL + "/\(id)/status", method: .GET, query: nil, body: nil))
  }
  
  func deleteTimer(id: Int) async throws {
   _ = try await networkManager.request(.init(path: self.timerBaseURL + "/\(id)", method: .DELETE, query: nil, body: nil))
  }
  
  func unlockTimer(timerId: String, failReason: String) async throws {
    _ = try await networkManager.request(.init(path: self.timerBaseURL + "/unlock", method: .POST, query: nil, body: nil))
  }
  
}
enum FailReason: String {
    case lackOfFocusIntention = "집중 의지가 부족해요"
    case needBreak = "휴식이 필요해요"
    case finishedEarly = "일정이 빨리 끝났어요"
    case emergency = "긴급한 상황이 발생했어요"
    case externalDisturbance = "외부의 방해가 있어요"
    case none = "에러가 발생하였습니다"
    
    var description: String {
        return self.rawValue
    }
}
