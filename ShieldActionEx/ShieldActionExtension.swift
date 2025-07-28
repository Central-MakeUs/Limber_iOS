//
//  ShieldActionExtension.swift
//  ShieldActionEx
//
//  Created by 양승완 on 7/16/25.
//

import ManagedSettings
import Foundation
import UserNotifications

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        let defaults = UserDefaults(suiteName: "group.com.limber")
        switch action {

        case .secondaryButtonPressed:
            defaults?.set(false, forKey: "changeView")
            completionHandler(.close)

        case .primaryButtonPressed:
            let content = UNMutableNotificationContent()
            content.title = "림버"
            content.body = "알림을 눌러 림버로 이동해주세요.\n림버에서 앱 잠금을 해제할 수 있어요!"
            content.interruptionLevel = .timeSensitive
            content.relevanceScore = 1.0

            if let tokenData = try? JSONEncoder().encode(application),
               let tokenString = String(data: tokenData, encoding: .utf8) {
                content.userInfo = ["appToken": tokenString]
            }

            let request = UNNotificationRequest(identifier: "urgent", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)

            defaults?.set(true, forKey: "changeView")

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                defaults?.set(false, forKey: "changeView")
            }
            completionHandler(.defer)
        @unknown default:
            fatalError()
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
}
