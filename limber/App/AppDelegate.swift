//
//  AppDelegate.swift
//  limber
//
//  Created by 양승완 on 7/17/25.
//


import UIKit
import UserNotifications
import ManagedSettings
import FamilyControls
import FirebaseFirestore
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
  
  @Published var currentViewId: SomeRoute?
  let timerRepo = TimerRepository()
  var appToken: ApplicationToken?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    Task {
      do {
        let deviceID = try DeviceID.shared.getOrCreate()
        let timers = try await timerRepo.getUserTimers(userId: deviceID)
        SharedData.defaultsGroup?.set(deviceID, forKey: SharedData.Keys.UDID.key)
        TimerSharedManager.shared.saveFocusSessions(timers)
      } catch {
        print("Erorr \(error)")
      }
    }

    
    
    
    
    return true
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    
    if let tokenString = response.notification.request.content.userInfo["appToken"] as? String,
       let tokenData = tokenString.data(using: .utf8),
       let appToken = try? JSONDecoder().decode(ApplicationToken.self, from: tokenData) {
      
      self.appToken = appToken
      self.currentViewId = .unlock(token: appToken)
      
    }
    else if
      let endedActivityName = response.notification.request.content.userInfo["endedActivityName"] as? String {
      self.currentViewId = .retrospective(id: endedActivityName)
    }
    
    
    completionHandler()
  }
  
  
  
}
