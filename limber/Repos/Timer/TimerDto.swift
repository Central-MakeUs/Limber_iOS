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
  var startTime: String
  var endTime: String
  var status: TimerStatus
  var timerCode: TimerCode?
  
  
  func getDays() -> String {
    
    let days = ["일", "월", "화", "수", "목", "금", "토"]
    let result = repeatDays.split(separator: ",")
      .compactMap { Int($0) }
      .map { days[$0] }
      .joined(separator: " ")
    return result.isEmpty ? "없음" : result
  }
  func getFocusTitle() -> String {
    return StaticValManager.titleDic[self.focusTypeId] ?? ""
  }
  
  func toModel() -> TimerModel {
    return TimerModel(id: self.id, title: self.title, focusTitle: self.getFocusTitle(), startTime: self.startTime, endTime: self.endTime, repeatDays: self.getDays(), repeatCycleCode: self.repeatCycleCode)
  }
}
struct LocalTime: Codable {
  let hour: Int
  let minute: Int
  let second: Int
  let nano: Int
  
}
