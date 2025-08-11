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
    case nowTimer = "nowTimer"
    case UDID = "UDID"
    
    var key: String {
      switch self {
        
      default: self.rawValue
      }
    }
  }
}
func getDeviceUUID() -> String {
  return UIDevice.current.identifierForVendor!.uuidString
}
