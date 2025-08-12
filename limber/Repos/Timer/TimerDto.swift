//
//  TimerDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//

import Foundation

struct TimerRequestDto: Codable {
  let userId: String
    let title: String
    let focusTypeId: Int
  let timerCode: TimerCode
    let repeatCycleCode: RepeatCycleCode
    let repeatDays: String
    let startTime: String
    let endTime: String
}

struct TimerResponseDto: Codable, Hashable {
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
  func getFocusTitle() -> String {
    let idDic: [Int: String] = [0: "학습",1: "업무", 2: "회의", 3: "직업",4: "기타"]
    return idDic[self.focusTypeId] ?? ""
  }
}
struct LocalTime: Codable {
    let hour: Int
    let minute: Int
    let second: Int
    let nano: Int
    
}


struct TimerNowDto: Codable {
  let focusTypeId: Int
  let startTime: String
  let endTime: String
}
