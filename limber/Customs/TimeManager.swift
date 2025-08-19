//
//  Time.swift
//  limber
//
//  Created by 양승완 on 7/31/25.
//

import Foundation
import Combine

class TimerObserver: ObservableObject {
  
  static let shared = TimerObserver()
    
  @Published var totalTime: TimeInterval = 0
  @Published var elapsed: TimeInterval = 0
  @Published var isFinished: Bool = false
  
  @Published var startDate: Date = .now
  @Published var endDate: Date = .now
  
  private var cancellable: AnyCancellable?
  
  func startTimer() {
    
    let nowDate = TimeManager.shared.parseTimeString(TimeManager.shared.HHmmssFormatter.string(from: .now))!
    let totalTime = endDate.timeIntervalSince(startDate)
    let nowtime = nowDate.timeIntervalSince(startDate)
    self.totalTime = totalTime
    self.elapsed = nowtime
    cancellable = Timer
      .publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] now in
        guard let self else { return }
        
        let nowDate = TimeManager.shared.parseTimeString(TimeManager.shared.HHmmssFormatter.string(from: now))!
        self.elapsed = nowDate.timeIntervalSince(self.startDate)
        
        if self.elapsed >= self.totalTime {
          self.elapsed = self.totalTime
          self.isFinished = true
          SharedData.defaultsGroup?.set(false, forKey: SharedData.Keys.isTimering.key)
          self.cancellable?.cancel()
        }
      }
  }
  func stopTimer() {
    NSLog("stopTimer:::")
    cancellable?.cancel()
      cancellable = nil
  }
  
  
}

class TimeManager: ObservableObject {
  
  static let shared = TimeManager()
  @Published var remaining: TimeInterval = 0
  @Published var isRunning = false
  
  var duration: TimeInterval = 0
  var startTime: Date?
  var timer: Timer?
  
  
  
  let HHmmssFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "HH:mm:ss"
    return formatter
  }()  
  
  let HHmmFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "HH:mm"
    return formatter
  }()
  
  let krMDFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M'월' d'일'"
    return formatter
  }()

  func addTime(to date: Date = .now, hours: Int = 0, minutes: Int = 0) -> Date? {
      var result = date
      if let addedHours = Calendar.current.date(byAdding: .hour, value: hours, to: result) {
          result = addedHours
      }
      if let addedMinutes = Calendar.current.date(byAdding: .minute, value: minutes, to: result) {
          result = addedMinutes
      }
      return result
  }
  
  func parseTimeString(_ timeString: String) -> Date? {
    let calendar = Calendar.current
    let today = Date()
    
    if let time = HHmmssFormatter.date(from: timeString) {
      let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
      let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
      
      var combinedComponents = DateComponents()
      
      combinedComponents.year = todayComponents.year
      combinedComponents.month = todayComponents.month
      combinedComponents.day = todayComponents.day
      combinedComponents.hour = timeComponents.hour
      combinedComponents.minute = timeComponents.minute
      combinedComponents.second = timeComponents.second
      
      return calendar.date(from: combinedComponents)
    }
    return nil
    
  }
  
  func timeString(from interval: TimeInterval) -> String {
    let hr = Int(interval) / 3600
    let min = (Int(interval) % 3600) / 60
    let sec = Int(interval) % 60
    return String(format: "%02d:%02d:%02d", hr, min, sec)
  }
  
  func timeStringToDateComponents(_ timeString: String, dateFormatStr: String = "ah시m분") -> DateComponents? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = dateFormatStr
    
    guard let date = formatter.date(from: timeString) else {
      return nil
    }
    
    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    return components
  }
  
  func timeStringToDate(_ timeString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "HH:mm"
    return formatter.date(from: timeString)
  }
  
  func isoToMMdd(_ iso: String,
                 timeZone: TimeZone = TimeZone(identifier: "Asia/Seoul")!) -> String? {
      let inFmt = DateFormatter()
      inFmt.locale = Locale(identifier: "en_US_POSIX")
      inFmt.timeZone = timeZone
      inFmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

      guard let date = inFmt.date(from: iso) else { return nil }

      let outFmt = DateFormatter()
      outFmt.locale = Locale(identifier: "en_US_POSIX")
      outFmt.timeZone = timeZone
      outFmt.dateFormat = "MMdd"                   // 출력: 0815

      return outFmt.string(from: date)
  }
  
  func weekStartString(for date: Date,
                       weekOffset: Int = 0,
                       timeZone: TimeZone = TimeZone(identifier: "Asia/Seoul")!) -> String {
      var cal = Calendar(identifier: .iso8601) // 월요일 시작
      cal.timeZone = timeZone
      
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.timeZone = timeZone
      
      guard let interval = cal.dateInterval(of: .weekOfYear, for: date) else {
          return formatter.string(from: date)
      }
      
      // weekOffset 만큼 주 단위 이동 (예: -1 = 지난주, 0 = 이번주, 1 = 다음주)
      if let shifted = cal.date(byAdding: .weekOfYear, value: weekOffset, to: interval.start) {
          return formatter.string(from: shifted)
      }
      
      return formatter.string(from: interval.start)
  }


  func weekEndString(for date: Date,
                     weekOffset: Int = 0,
                     timeZone: TimeZone = TimeZone(identifier: "Asia/Seoul")!) -> String {
      var cal = Calendar(identifier: .iso8601)
      cal.timeZone = timeZone
      
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.timeZone = timeZone
      
      guard let interval = cal.dateInterval(of: .weekOfYear, for: date) else {
          return formatter.string(from: date)
      }
      
      // weekOffset 만큼 주 단위 이동
      guard let shiftedStart = cal.date(byAdding: .weekOfYear, value: weekOffset, to: interval.start) else {
          return formatter.string(from: interval.start)
      }
      
      // 이동한 주의 끝 날짜 (시작 + 6일)
      let endDate = cal.date(byAdding: .day, value: 6, to: shiftedStart)!
      return formatter.string(from: endDate)
  }
  func minutesToHourMinuteString(_ minutes: Int) -> String {
      let hours = minutes / 60
      let remainingMinutes = minutes % 60
      if hours > 0 {
          return "\(hours)시간 \(remainingMinutes)분"
      } else {
          return "\(remainingMinutes)분"
      }
  }
}
