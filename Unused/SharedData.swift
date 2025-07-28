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
        
        var key: String {
            switch self {
            
            default: self.rawValue
            }
        }
    }
}
//TODO: remove
func getDeviceUUID() -> String {
    return UIDevice.current.identifierForVendor!.uuidString
}
