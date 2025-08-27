//
//  TimerRetrospectResponseDto.swift
//  limber
//
//  Created by 양승완 on 8/27/25.
//



struct TimerRetrospectResponseDto: Decodable {
  let id: Int
  let timerHistoryId: Int
  let timerId: Int
  let userId: String
  let immersion: Int
  let comment: String
  let delFlag: String
}
