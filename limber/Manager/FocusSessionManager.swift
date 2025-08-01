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
  func loadFocusSessions() -> [FocusSessionDTO] {
    if let data = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.focusSessions.key) {
          let decoder = JSONDecoder()
          if let sessions = try? decoder.decode([FocusSessionDTO].self, from: data) {
              return sessions
          }
      }
      return []
  }
  
  func saveFocusSessions(_ sessions: [FocusSessionDTO]) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(sessions) {
      SharedData.defaultsGroup?.set(data, forKey: SharedData.Keys.focusSessions.key)
    }
  }
}
