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
  
  var uuid: String = UUID().uuidString
  
  var name: String
  var focusTitle: String
  var startTime: String
  var endTime: String
  var repeatType: String
  var isOn: Bool
  var days: String
  
  init(name: String, focusTitle: String, startTime: String, endTime: String, repeatType: String, isOn: Bool, days: String) {
    self.name = name
    self.focusTitle = focusTitle
    self.startTime = startTime
    self.endTime = endTime
    self.repeatType = repeatType
    self.isOn = isOn
    self.days = days
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
}

struct FocusSessionDTO: Codable {
  var uuid: String
  var name: String
  var focusTitle: String
  var startTime: String
  var endTime: String
  var repeatType: String
  var isOn: Bool
  
  var days: String
  
  func getDays() -> [String] {
    return days.components(separatedBy: ",")
  }
  
  init(name: String, focusTitle: String, startTime: String, endTime: String, repeatType: String, isOn: Bool, uuid: String, days: String) {
    self.name = name
    self.focusTitle = focusTitle
    self.startTime = startTime
    self.endTime = endTime
    self.repeatType = repeatType
    self.isOn = isOn
    self.uuid = uuid
    self.days = days
  }
}
