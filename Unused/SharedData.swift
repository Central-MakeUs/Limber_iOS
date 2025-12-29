//
//  SharedData.swift
//  limber
//
//  Created by 양승완 on 7/6/25.
//

import Foundation
import UIKit


class SharedData {
  static let defaultsGroup: UserDefaults? = UserDefaults(suiteName: "group.com.limber")
  
  enum Keys: String {
    case isUserPremium = "isUserPremiumKey"
    case totalAppsDuration = "totalAppsDuration"
    case pickedApps = "pickedApps"
    case isTimering = "isTimering"
    case timeringObject = "timeringObject"
    case allApps = "allApps"
    case schedules = "schedules"
    case focusSessions = "focusSessions"
    case nowTimerKey = "nowTimerKey"
    case UDID = "UDID"
    case timerModels = "timerModels"
    case historyTimer = "historyTimer"
    case historyTimerKey = "historyTimerKey"
    case doNotNoti = "doNotNoti"
    case pendingHistories = "pendingHistories"

    
    var key: String {
      switch self {
        
      default: self.rawValue
      }
    }
  }
}

struct PendingTimerHistory: Codable {
  let timerId: Int
  let userId: String
  let title: String
  let focusTypeId: Int
  let repeatCycleCode: String
  let repeatDays: String
  let startTime: String
  let endTime: String
  let historyTimestamp: TimeInterval
  let historyStatus: String
  let failReason: String?
  let focusTypeTitle: String?
}
func getDeviceUUID() -> String {
  return UIDevice.current.identifierForVendor!.uuidString
}
