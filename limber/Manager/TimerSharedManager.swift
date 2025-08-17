//
//  FocusSessionManager.swift
//  limber
//
//  Created by 양승완 on 8/2/25.
//

import Foundation

class TimerSharedManager {
  static let shared = TimerSharedManager()
  
  private init() {
    
  }
  
  func getHistoryTimer() -> TimerHistoryResponseDto? {
    NSLog("getHistoryTImer:::1")
    
    if let data = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.historyTimer.key) {
      let decoder = JSONDecoder()
      if let dto = try? decoder.decode(TimerHistoryResponseDto.self, from: data) {
        NSLog("getHistoryTImer:::2 \(dto)")
        return dto
      }
    }
    return nil
  }
   
  func setHistoryTimer(dto: TimerHistoryResponseDto) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(dto) {
      SharedData.defaultsGroup?.set(data, forKey: SharedData.Keys.historyTimer.key)
    }
  }
  
  func getHistoryTimerKey() -> String? {
    
    return SharedData.defaultsGroup?.string(forKey: SharedData.Keys.historyTimerKey.key)
        
  }
   
  func setHistoryTimer(key: String) {
    SharedData.defaultsGroup?.set(key, forKey: SharedData.Keys.historyTimerKey.key)
  }
  
  func saveTimerModels(_ sessions: [TimerModel]) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(sessions) {
      SharedData.defaultsGroup?.set(data, forKey: SharedData.Keys.timerModels.key)
    }
  }
  func getTimerModels() -> [TimerModel] {
    if let data = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.timerModels.key) {
      let decoder = JSONDecoder()
      if let sessions = try? decoder.decode([TimerModel].self, from: data) {
        return sessions
      }
    }
    return []
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
  
  func saveTimeringSession(_ session: Any?) {
    let encoder = JSONEncoder()
    if let responseDto = session as? TimerResponseDto  ,let data = try? encoder.encode(responseDto) {
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

  func addTimer(dto: TimerResponseDto) {
    var datas: [TimerResponseDto] = self.loadFocusSessions()
    datas.append(dto)
    self.saveFocusSessions(datas)
  }
  

  
}
