//
//  DeviceActivityMonitorExtension.swift
//  limber_ActivityMonitor
//
//  Created by 양승완 on 6/23/25.
//

import DeviceActivity
import Foundation
import ManagedSettings
import UserNotifications


extension ManagedSettingsStore.Name {
  static let total = Self("total")
}

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.

struct PickedAppModel: Codable, Hashable, Equatable {
  static func == (lhs: PickedAppModel, rhs: PickedAppModel) -> Bool {
    return lhs.token == rhs.token
  }
  
  init(displayName: String, token: ApplicationToken?) {
    self.displayName = displayName
    self.token = token
  }
  let displayName: String
  let token: ApplicationToken?
}

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
  
  override func intervalDidStart(for activity: DeviceActivityName) {
    super.intervalDidStart(for: activity)
    
    let newStore = ManagedSettingsStore(named: .init(activity.rawValue))
    newStore.clearAllSettings()
    
    if let data = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.pickedApps.key) {
      let decoder = JSONDecoder()
      if let apps = try? decoder.decode([PickedAppModel].self, from: data) {
        var set = Set<ApplicationToken>()
        apps.forEach {
          if let token = $0.token {
            set.insert(token)
          }
        }
        newStore.shield.applications = set
      }
    }
    //        let store = ManagedSettingsStore(named: .init(activity.rawValue))
    if let sessions = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.focusSessions.key) {
      let decoder = JSONDecoder()
      do {
        let focusSession = try decoder.decode([FocusSessionDTO].self, from: sessions)
        if let idx = focusSession.map({ $0.uuid }).firstIndex(of: activity.rawValue) {
          
          let today = Date()
          let calendar = Calendar.current
          let weekdayNumber = calendar.component(.weekday, from: today)
          
          if focusSession[idx].days.contains(weekdayNumber) {
            SharedData.defaultsGroup?.set(activity, forKey: SharedData.Keys.timeringName.key)
            SharedData.defaultsGroup?.set(true, forKey: SharedData.Keys.isTimering.key)
          }
          
        }
      } catch {
        
      }
    }
  }
  
  override func intervalDidEnd(for activity: DeviceActivityName) {
    super.intervalDidEnd(for: activity)
    let defaults = UserDefaults(suiteName: "group.com.limber")
    let store = ManagedSettingsStore(named: .init(activity.rawValue))
    store.shield.applications = []
    
    let content = UNMutableNotificationContent()
    content.title = "림버"
    content.body = "타이머가 종료되었어요!\n앱에서 회고를 진행해주세요!"
    content.interruptionLevel = .timeSensitive
    content.relevanceScore = 1.0
    
    let request = UNNotificationRequest(identifier: "intervalDidEnd", content: content, trigger: nil)
    UNUserNotificationCenter.current().add(request)
    
    SharedData.defaultsGroup?.set(false, forKey: SharedData.Keys.isTimering.key)
    
    //        defaults?.set(true, forKey: "changeView")
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    //            defaults?.set(false, forKey: "changeView")
    //        }
    
  }
  
  override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
    super.eventDidReachThreshold(event, activity: activity)
    
    // Handle the event reaching its threshold.
  }
  
  override func intervalWillStartWarning(for activity: DeviceActivityName) {
    super.intervalWillStartWarning(for: activity)
    
    // Handle the warning before the interval starts.
  }
  
  override func intervalWillEndWarning(for activity: DeviceActivityName) {
    super.intervalWillEndWarning(for: activity)
    
    // Handle the warning before the interval ends.
  }
  
  override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
    super.eventWillReachThresholdWarning(event, activity: activity)
    
    // Handle the warning before the event reaches its threshold.
  }
}
