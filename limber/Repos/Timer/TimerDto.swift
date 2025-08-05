//
//  TimerDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//

import Foundation

struct TimerRequestDto: Codable {
    let userId: Int
    let title: String
    let focusTypeId: Int
    let repeatCycleCode: RepeatCycleCode
    let repeatDays: String       // ex: "MON,TUE,WED"
    let startTime: String        // "HH:mm:ss"
    let endTime: String          // "HH:mm:ss"
}

struct TimerResponseDto: Codable {
    let id: Int
    let title: String
    let focusTypeId: Int
    let repeatCycleCode: RepeatCycleCode
    let repeatDays: String
    let startTime: String        // "HH:mm:ss"
    let endTime: String          // "HH:mm:ss"
    let status: TimerStatus
}


