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
    let historyDt: String     
    let historyStatus: HistoryStatus
    let failReason: String?
    let startTime: String
    let endTime: String
}
