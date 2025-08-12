//
//  FocusSession.swift
//  limber
//
//  Created by 양승완 on 7/25/25.
//

import DeviceActivity
import SwiftData
import Foundation


struct TimerModel {
  var id: Int
  var title: String
  var focusTitle: String
  var startTime: String
  var endTime: String
  var repeatDays: String
  var focusTypeId: Int
  let repeatCycleCode: RepeatCycleCode

  init(id: Int, title: String, focusTitle: String, startTime: String, endTime: String, repeatDays: String, repeatCycleCode: RepeatCycleCode) {
    let titleDic: [String: Int] = ["학습": 1,"업무": 2,"회의": 3,"직업": 4,"기타": 5]
    self.id = id
    self.title = title
    self.focusTitle = focusTitle
    self.startTime = startTime.replacingOccurrences(of: " ", with: "")
    self.endTime = endTime.replacingOccurrences(of: " ", with: "")
    self.repeatDays = repeatDays
    self.repeatCycleCode = repeatCycleCode
    focusTypeId = titleDic[focusTitle] ?? 0

  }
  var totalDuration: TimeInterval? {
    guard
      let start = TimeManager.shared.timeStringToDate(startTime),
      let end = TimeManager.shared.timeStringToDate(endTime)
    else { return nil }
    return end.timeIntervalSince(start)
  }

  
    func convertKoreanTimeTo24Hour(_ timeString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.dateFormat = "ah시m분"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"

        if let date = inputFormatter.date(from: timeString) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
  
  
//  func getResponseDto() -> TimerResponseDto {
//      return TimerResponseDto(id: self.id, title: self.name, focusTypeId: 1, repeatCycleCode: .every, repeatDays: self.days, startTime: self.startTime, endTime: self.endTime, status: self.isOn ? .running : .ready)
//  }
  
  func getRequestDto(userId: String, timerCode: TimerCode) -> TimerRequestDto {
    return TimerRequestDto(userId: userId, title: self.title, focusTypeId: focusTypeId, timerCode: timerCode, repeatCycleCode: repeatCycleCode, repeatDays: self.repeatDays, startTime: convertKoreanTimeTo24Hour(self.startTime) ?? "", endTime: convertKoreanTimeTo24Hour(self.endTime) ?? "")
 
  }
}

//struct FocusSessionDTO: Codable {
//  var uuid: String
//  var name: String
//  var focusTitle: String
//  var startTime: String
//  var endTime: String
//  var repeatType: String
//  var isOn: Bool
//  
//  var days: String
//  
//  func getDays() -> [String] {
//    return days.components(separatedBy: ",")
//  }
//  
//  init(name: String, focusTitle: String, startTime: String, endTime: String, repeatType: String, isOn: Bool, uuid: String, days: String) {
//    self.name = name
//    self.focusTitle = focusTitle
//    self.startTime = startTime
//    self.endTime = endTime
//    self.repeatType = repeatType
//    self.isOn = isOn
//    self.uuid = uuid
//    self.days = days
//  }
//}
