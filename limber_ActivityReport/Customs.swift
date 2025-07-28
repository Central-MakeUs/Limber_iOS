//
//  Customs.swift
//  limber
//
//  Created by 양승완 on 7/23/25.
//

import Foundation
import ManagedSettings
import _DeviceActivity_SwiftUI


extension TimeInterval {
    func toString() -> String {
        let time = NSInteger(self)
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%d시간 %d분", hours,minutes)
    }
    
    func toMinute() -> Double {
        let time = NSInteger(self)
        let minutes = (time / 60) + (time / 60) % 60
        return Double(minutes)
    }
}

extension DeviceActivityReport.Context {
    static let totalActivity = Self("Total Activity")
}

struct ActivityReport {
    let totalDuration: TimeInterval
    let apps: [AppDeviceActivity]
    
    var focusTotalDuration: TimeInterval
    var focuses: [FocusSession]
}

struct AppDeviceActivity: Identifiable {
    var id: String
    var displayName: String
    var duration: TimeInterval
    var numberOfPickups: Int
    var token: ApplicationToken?
}
