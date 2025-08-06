//
//  FocusSession.swift
//  limber
//
//  Created by 양승완 on 7/25/25.
//

import DeviceActivity
import SwiftData
import Foundation

@Model
class FocusSession {

  var id: Int = {
    return Int.random(in: 0...99999999) + Date.now.hashValue
  }()
  
  var name: String
  var focusTitle: String
  var startTime: String
  var endTime: String
  var repeatType: String
  var isOn: Bool
  var days: String
  var focusTitleId: Int
  
  init(name: String, focusTitle: String, startTime: String, endTime: String, repeatType: String, isOn: Bool, days: String) {
    let titleDic: [String: Int] = ["학습": 0,"업무": 1,"회의": 2,"직업": 3,"기타": 4]
    self.name = name
    self.focusTitle = focusTitle
    self.startTime = startTime
    self.endTime = endTime
    self.repeatType = repeatType
    self.isOn = isOn
    self.days = days
    focusTitleId = titleDic[focusTitle] ?? 0

  }
  var totalDuration: TimeInterval? {
    guard
      let start = timeStringToDate(startTime),
      let end = timeStringToDate(endTime)
    else { return nil }
    return end.timeIntervalSince(start)
  }
  
  //TODO: exension 으로
  func timeStringToDate(_ timeString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "ah시m분"
    return formatter.date(from: timeString)
  }
  
  func getDto() -> TimerResponseDto {
    return TimerResponseDto(id: self.id, title: self.name, focusTypeId: 1, repeatCycleCode: .every, repeatDays: self.days, startTime: self.startTime, endTime: self.endTime, status: self.isOn ? .running : .ready)
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
