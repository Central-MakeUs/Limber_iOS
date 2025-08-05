//
//  Time.swift
//  limber
//
//  Created by 양승완 on 7/31/25.
//

import Foundation
import Combine

class TimerManager1: ObservableObject {
    @Published var totalTime: TimeInterval = 0
    @Published var elapsed: TimeInterval = 0
    @Published var isFinished: Bool = false


    private var startDate: Date = .now
    private var endDate: Date = .now

    private var cancellable: AnyCancellable?

    init(startDate: Date, endDate: Date) {
      
      
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.dateFormat = "ah시m분ss"
      let nowDate = TimeManager.shared.parseTimeString(formatter.string(from: .now))!
      let totalTime = endDate.timeIntervalSince(startDate)
      let nowtime = nowDate.timeIntervalSince(startDate)
      self.totalTime = totalTime
      self.elapsed = nowtime


        // 타이머 시작
        startTimer()
    }

    private func startTimer() {
        cancellable = Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                guard let self else { return }

                self.elapsed = now.timeIntervalSince(self.startDate)

                if self.elapsed >= self.totalTime {
                    self.elapsed = self.totalTime
                    self.isFinished = true
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
  
  func parseTimeString(_ timeString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "ah시m분ss"
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
    formatter.dateFormat = "ah시m분" // 공백 주의 (예: "오후 2시 10분")
    
    guard let date = formatter.date(from: timeString) else {
      return nil
    }
    
    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    return components
  }
  
  
  func start(duration: TimeInterval) {
    self.duration = duration
    self.startTime = Date()
    self.remaining = duration
    self.isRunning = true
    
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.tick()
    }
  }
  
  func stop() {
    timer?.invalidate()
    timer = nil
    isRunning = false
  }
  
  private func tick() {
    guard let start = startTime else { return }
    let elapsed = Date().timeIntervalSince(start)
    let newRemaining = duration - elapsed
    
    if newRemaining <= 0 {
      remaining = 0
      stop()
      print("완료")
    } else {
      remaining = newRemaining
      print("남은 시간: \(Int(remaining))초")
    }
  }
  
  
}
