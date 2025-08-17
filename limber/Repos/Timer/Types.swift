//
//  TimerStatusUpdateDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//

import Foundation

struct TimerAllFetchStatusRequest: Codable {
  let userId: String
  let timerCode: String
  let status: String
}

struct TimerAllFetchStatusResponse: Codable {
    let id: Int
    let title: String
    let focusTypeId: Int
    let repeatCycleCode: String
    let repeatDays: String
    let startTime: String
    let endTime: String
    let status: String
}

struct TimerFailDecoder: Codable {
  let success: Bool
  let data: TimerFailDto
  let error: String?
}

struct TimerFailDto: Codable {
  let timerId: Int
  let failReason: String
  
}

struct TimerOnceDecoder: Codable {
  let success: Bool
  let data: TimerResponseDto
  let error: String?
}

struct TimerArrayDecoder: Codable {
  let success: Bool
  let data: [TimerResponseDto]
  let error: String?
}

struct TimerAllFetchStatusDecoder: Codable {
  let success: Bool
  let data: TimerAllFetchStatusResponse
  let error: String?
}

struct TimerUnlockDecoder: Codable {
  let success: Bool
  let data: TimerUnlockDecoderDto
  let error: String?
}

struct TimerUnlockDecoderDto: Codable {
  let timerId: Int
  let failReason: String
}

struct TimerStatusUpdateDto: Codable {
  let status: TimerStatus
}

enum TimerRepositoryError: Error {
  case invalidURL
  case decodingError
  case httpError(code: Int)
}
enum RepeatCycleCode: String, Codable {
  case EVERY   = "EVERY"
  case WEEKDAY = "WEEKDAY"
  case WEEKEND = "WEEKEND"
  case NONE = "NONE"
}

enum TimerStatus: String, Codable {
  case ON = "ON"
  case OFF = "OFF"
}
enum TimerCode: String, Codable {
  case SCHEDULED = "SCHEDULED"
  case IMMEDIATE = "IMMEDIATE"
}
