//
//  TimerStatusUpdateDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//

import Foundation

struct TimerOnceDecoder: Codable {
    let success: Bool
    let data: TimerResponseDto
    let error: String?
}

struct TimerArrayDecoder: Codable {
    let success: Bool
    let data: [TimerResponseDto]
    let error: String?
}

struct TimerStatusUpdateDto: Codable {
    let status: TimerStatus
}

enum TimerRepositoryError: Error {
    case invalidURL
    case decodingError
    case httpError(code: Int)
}
enum RepeatCycleCode: String, Codable {
    case EVERY   = "EVERY"
    case WEEKDAY = "WEEKDAY"
    case WEEKEND = "WEEKEND"
  case NONE = "NONE"
}

enum TimerStatus: String, Codable {
    case ready     = "READY"      // 예약됨 (시작 전)
    case running   = "RUNNING"    // 진행 중
    case paused    = "PAUSED"     // 일시정지
    case completed = "COMPLETED"  // 종료됨
    case canceled  = "CANCELED"   // 취소됨
}
enum TimerCode: String, Codable {
  case SCHEDULED = "SCHEDULED"
  case IMMEDIATE = "IMMEDIATE"
}
