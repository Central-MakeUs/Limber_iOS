//
//  TimerHistoryResponseDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//

import Foundation



struct TimerHistoryResponseDto: Codable, Identifiable {
  let id: Int
  let timerId: Int
  let userId: String
  let title: String
  let focusTypeId: Int
  let repeatCycleCode: String
  let repeatDays: String
  let historyDt: String
  let historyStatus: String
  let failReason: String?
  let startTime: String
  let endTime: String
  let hasRetrospect: Bool
  let retrospectId: Int?
  let retrospectImmersion: Int?
  let retrospectComment: String?
  let focusTypeTitle: String
  let retrospectSummary: String
  
  
  func getImmersionImg() -> String {
    let immersion = retrospectImmersion ?? 0
    return immersion > 60 ? "100Ribbon" : immersion > 20 ? "60Ribbon" : "20Ribbon"
  }

}
struct TimerHistorySearchDto: Codable {
  let userId: String
  let searchRange: String
  let onlyIncompleteRetrospect: Bool  
}
struct TimerWeeklyHistoryResponseDto: Codable, Identifiable {
  var id: String { UUID().description }
  let weekStart: String
  let weekEnd: String
  let items: [TimerHistoryResponseDto]
}
struct WeekdayActualDto: Decodable {
    let weekdayIndex: Int
    let dayOfWeek: String
    let totalActualMinutes: Int
}

struct WeekdayImmersionDto: Decodable {
    let weekdayIndex: Int
    let dayOfWeek: String
    let totalActualMinutes: Int
    let totalScheduledMinutes: Int
    /// ratio = 실제 / 예정
    let ratio: Double
}

struct TotalActualDto: Decodable {
    let totalMinutes: Int
    /// 사람이 읽기 좋은 "X시간 Y분"
    let label: String
}

struct TotalImmersionDto: Decodable {
    let totalActualMinutes: Int
    let totalScheduledMinutes: Int
    let ratio: Double
}

struct FocusDistributionDto: Decodable {
  let focusTypeId: Int
  let focusTypeName: String
  let totalActualMinutes: Int
}

struct FailReasonCountDto: Decodable {
    let failReason: String
    let count: Int
}


