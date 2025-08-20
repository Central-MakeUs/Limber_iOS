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
  
  @Published var isForeGround: Bool = false

  weak var router: AppRouter?

  var appToken: ApplicationToken?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    do {
      let deviceID = try DeviceID.shared.getOrCreate()
      SharedData.defaultsGroup?.set(deviceID, forKey: SharedData.Keys.UDID.key)
    } catch {
      
    }
    return true
  }
  
  
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    TimerObserver.shared.stopTimer()
    if isForeGround {
      router?.push(.circularTimer)
      isForeGround = false
      return
    }
    
    if  response.notification.request.identifier == "urgent"  {
      self.currentViewId = .unlock
      
    } else if let timerId = response.notification.request.content.userInfo["timerId"] as? String {
      
      TimerSharedManager.shared.setHistoryTimer(key: timerId)
      
      self.currentViewId = .circularTimer
    } else {
      self.currentViewId = .circularTimer

    }
    
    
    completionHandler()
  }
 
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    isForeGround = true
      if #available(iOS 14.0, *) {
          completionHandler([.banner, .list, .sound])
      } else {
          completionHandler([.alert, .sound])
      }
  }
}
