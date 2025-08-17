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
    
    let newStore = ManagedSettingsStore(named: .total)
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
    SharedData.defaultsGroup?.set(true, forKey: SharedData.Keys.isTimering.key)
    SharedData.defaultsGroup?.set(activity.rawValue, forKey: SharedData.Keys.nowTimerKey.key)
    
    let focusSession = TimerSharedManager.shared.loadFocusSessions()
    if let idx = focusSession.map({ $0.id.description }).firstIndex(of: activity.rawValue) {
      let today = Date()
      let calendar = Calendar.current
      let weekdayNumber = calendar.component(.weekday, from: today)
      if focusSession[idx].repeatDays.split(separator: ",").contains("\(weekdayNumber)") {
        TimerSharedManager.shared.saveTimeringSession(focusSession[idx])
      }
      
    }
    
    
  }
  
  override func intervalDidEnd(for activity: DeviceActivityName) {
    super.intervalDidEnd(for: activity)
    let store = ManagedSettingsStore(named: .total)
    store.shield.applications = []
    let content = UNMutableNotificationContent()
    content.title = "림버"
    content.body = "타이머가 종료되었어요!\n앱에서 회고를 진행해주세요!"
    content.interruptionLevel = .timeSensitive
    content.relevanceScore = 1.0
    content.userInfo = ["timerId": activity.rawValue]

    Task {
      NSLog("intervalDidEnd:::")
      do {
        SharedData.defaultsGroup?.set(false, forKey: SharedData.Keys.isTimering.key)
        TimerSharedManager.shared.deleteTimerSession(timerSessionId: 0)
        
        let request = UNNotificationRequest(identifier: "intervalDidEnd", content: content, trigger: nil)
        try await UNUserNotificationCenter.current().add(request)
      } catch {
        NSLog("::: error \(error)")
      }
    
      
      
    }
          
      
     
      
    
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
