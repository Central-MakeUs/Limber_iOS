//
//  ContentVM.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import FamilyControls
import Foundation
import ManagedSettings

import SwiftUI
import DeviceActivity
extension ManagedSettingsStore.Name {
    static let new = Self("new")
}
extension DeviceActivityName {
    static let new = Self("new")
}
struct BlockedModel {
    let token: String
    let displayName: String
}

class BlockVM: ObservableObject {
    
    let store = ManagedSettingsStore(named: .new)
    
    @Published var appSelection = FamilyActivitySelection(includeEntireCategory: true)
    @Published var applicationTokens = Set<ApplicationToken>()
    
    func setShieldRestrictions() {
        let deviceActivityCenter = DeviceActivityCenter()
        
        store.shield.applications = appSelection.applicationTokens.isEmpty ? nil : appSelection.applicationTokens
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 22,minute: 00, weekday: 0),
            intervalEnd: DateComponents(hour: 22, minute: 40),
            repeats: true)
        
        do {
            try deviceActivityCenter.startMonitoring(.new , during: schedule)
            
        } catch {
            print("err \(error)")
        }
    }
    
    func removeForShieldRestrictions(appToken: ApplicationToken) {
        store.shield.applications = store.shield.applications?.filter { $0 != appToken }
    }
    
    func finishPick() {
        applicationTokens = appSelection.applicationTokens
    }
    
    
    func reset() {
        
        appSelection.applicationTokens = store.shield.applications ?? []
        _ = appSelection.applicationTokens.map {
            print($0.hashValue)
        }
        
        applicationTokens = store.shield.applications ?? []
        
    }
    
}
