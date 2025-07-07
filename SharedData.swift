//
//  SharedData.swift
//  limber
//
//  Created by 양승완 on 7/6/25.
//

import Foundation


class SharedData {
    static let defaultsGroup: UserDefaults? = UserDefaults(suiteName: "group.com.limber.sharedData")
    
    enum Keys: String {
        case isUserPremium = "isUserPremiumKey"
        
        var key: String {
            switch self {
            default: self.rawValue
            }
        }
    }
}
