//
//  TimerRetrospectRequestDto.swift
//  limber
//
//  Created by 양승완 on 8/27/25.
//


struct TimerRetrospectRequestDto: Encodable {
  let userId: String
  let timerHistoryId: Int
  let timerId: Int
  let immersion: Int
  let comment: String
}
