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

struct BlockedModel {
    let token: String
    let displayName: String
}

class BlockVM: ObservableObject {
    
    let store = ManagedSettingsStore()
    
    @Published var appSelection = FamilyActivitySelection(includeEntireCategory: true)
    @Published var applicationTokens = Set<ApplicationToken>()
    
    var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")

    func setShieldRestrictions() {
        store.shield.applications = appSelection.applicationTokens.isEmpty ? nil : appSelection.applicationTokens
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
