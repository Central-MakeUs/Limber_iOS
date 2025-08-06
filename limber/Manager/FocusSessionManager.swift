//
//  FocusSessionManager.swift
//  limber
//
//  Created by 양승완 on 8/2/25.
//

import Foundation

class FocusSessionManager {
  static let shared = FocusSessionManager()
  
  private init() {
    
  }
  func loadFocusSessions() -> [TimerResponseDto] {
    if let data = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.focusSessions.key) {
      let decoder = JSONDecoder()
      if let sessions = try? decoder.decode([TimerResponseDto].self, from: data) {
        return sessions
      }
    }
    return []
  }
  
  func saveFocusSessions(_ sessions: [TimerResponseDto]) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(sessions) {
      SharedData.defaultsGroup?.set(data, forKey: SharedData.Keys.focusSessions.key)
    }
  }
  
  func saveTimeringSession(_ session: TimerResponseDto?) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(session) {
      SharedData.defaultsGroup?.set(data, forKey: SharedData.Keys.timeringObject.key)
    } else {
      SharedData.defaultsGroup?.set(nil, forKey: SharedData.Keys.timeringObject.key)
    }
  }
  
  func getTimeringSession() -> TimerResponseDto? {
    if let data = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.timeringObject.key) {
      let decoder = JSONDecoder()
      if let reponse = try? decoder.decode(TimerResponseDto.self, from: data) {
        return reponse
      }
    }
    return nil
  }
  
  func deleteTimerSession(timerSessionId: Int) {
    if let datas = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.focusSessions.key) {
      let decoder = JSONDecoder()
      if var reponses = try? decoder.decode([TimerResponseDto].self, from: datas) {
        reponses = reponses.filter { $0.id != timerSessionId }
        self.saveFocusSessions(reponses)
      }
    }
  }
  
  func getFromId(timerSessionId: String) -> TimerResponseDto? {
    let sessions = loadFocusSessions()
    return sessions.filter {
      $0.id.description == timerSessionId
    }.first
  }
  
}
