//
//  TimerHistoryResponseDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


// MARK: - DTO

/// 타이머 히스토리 응답용 DTO
struct TimerHistoryResponseDto: Codable {
    let id: Int
    let timerId: Int
    let userId: Int
    let title: String
    let focusTypeId: Int
    let repeatCycleCode: RepeatCycleCode
    let repeatDays: String
    let historyDt: String      // "yyyy-MM-dd'T'HH:mm:ss"
    let historyStatus: HistoryStatus
    let failReason: String?    // 실패 사유 (nullable)
    let startTime: String      // "HH:mm:ss"
    let endTime: String        // "HH:mm:ss"
}
