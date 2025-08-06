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
    let repeatDays: String
    let startTime: String
    let endTime: String
}

struct TimerResponseDto: Codable {
    let id: Int
    let title: String
    let focusTypeId: Int
    let repeatCycleCode: RepeatCycleCode
    let repeatDays: String
    let startTime: String
    let endTime: String
    let status: TimerStatus
  
  func getDays() -> [String] {
    return repeatDays.components(separatedBy: ",")
  }
}


