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

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
    
    @Published var currentViewId: SomeRoute?
    var appToken: ApplicationToken?
    var router: AppRouter?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
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
        
        completionHandler()
    }
    

    
}
