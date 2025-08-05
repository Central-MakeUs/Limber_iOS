//
//  TimerStatusUpdateDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//

import Foundation
struct TimerStatusUpdateDto: Codable {
    let status: TimerStatus
}

enum TimerRepositoryError: Error {
    case invalidURL
    case decodingError
    case httpError(code: Int)
}
enum RepeatCycleCode: String, Codable {
    case every   = "EVERY"    // 매일 반복
    case weekday = "WEEKDAY"  // 평일 반복 (월~금)
    case weekend = "WEEKEND"  // 주말 반복 (토~일)
}

enum TimerStatus: String, Codable {
    case ready     = "READY"      // 예약됨 (시작 전)
    case running   = "RUNNING"    // 진행 중
    case paused    = "PAUSED"     // 일시정지
    case completed = "COMPLETED"  // 종료됨
    case canceled  = "CANCELED"   // 취소됨
}
