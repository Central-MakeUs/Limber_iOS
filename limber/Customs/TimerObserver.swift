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
    
    let nowDate = TimeManager.shared.parseFullDateTimeString(TimeManager.shared.fullDateTimeFormatter.string(from: .now))!
    let totalTime = endDate.timeIntervalSince(startDate)
    let nowtime = nowDate.timeIntervalSince(startDate)
    self.totalTime = totalTime
    self.elapsed = nowtime
    cancellable = Timer
      .publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] now in
        guard let self else { return }
        
        let nowDate = TimeManager.shared.parseFullDateTimeString(TimeManager.shared.fullDateTimeFormatter.string(from: now))!
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
    totalTime = 0
    elapsed = 0
    cancellable?.cancel()
    cancellable = nil
  }
  
  
}

