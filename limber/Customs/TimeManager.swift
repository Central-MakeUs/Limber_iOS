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
  
  var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "ah시m분ss"
    return formatter
  }()
  
  func startTimer() {
    
    let nowDate = TimeManager.shared.parseTimeString(formatter.string(from: .now))!
    let totalTime = endDate.timeIntervalSince(startDate)
    let nowtime = nowDate.timeIntervalSince(startDate)
    self.totalTime = totalTime
    self.elapsed = nowtime
    cancellable = Timer
      .publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] now in
        guard let self else { return }
        
        let nowDate = TimeManager.shared.parseTimeString(formatter.string(from: now))!
        self.elapsed = nowDate.timeIntervalSince(self.startDate)
        
        if self.elapsed >= self.totalTime {
          self.elapsed = self.totalTime
          self.isFinished = true
          SharedData.defaultsGroup?.set(false, forKey: SharedData.Keys.isTimering.key)
          self.cancellable?.cancel()
        }
      }
  }
}

class TimeManager: ObservableObject {
  
  static let shared = TimeManager()
  @Published var remaining: TimeInterval = 0
  @Published var isRunning = false
  
  var duration: TimeInterval = 0
  var startTime: Date?
  var timer: Timer?
  
  let formatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "ah시m분ss"
    return formatter
  }()
  
  let dateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M'월' d'일'"
    return formatter
  }()

  
  func parseTimeString(_ timeString: String) -> Date? {

    // 오늘 날짜 기준으로 시간 설정
    let calendar = Calendar.current
    let today = Date()
    
    if let time = formatter.date(from: timeString) {
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
  
  func timeStringToDateComponents(_ timeString: String) -> DateComponents? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "ah시m분"
    
    guard let date = formatter.date(from: timeString) else {
      return nil
    }
    
    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    return components
  }
  
 
  
  
}
