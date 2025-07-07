//
//  ContentVM.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import FamilyControls
import Foundation
import ManagedSettings

struct BlockedModel {
    let token: String
    let displayName: String
}

class BlockVM: ObservableObject {
    
    
    let center = AuthorizationCenter.shared
    let store = ManagedSettingsStore()
    
    @Published var appSelection = FamilyActivitySelection(includeEntireCategory: true)
    @Published var appCount = 0
    
    func setShieldRestrictions() {
        
        store.shield.applications = appSelection.applicationTokens.isEmpty ? nil : appSelection.applicationTokens
        
        appSelection.applications.forEach  {
            var list: [Data:String] = [:]
            if let encoded = try? JSONEncoder().encode($0.token) {
                list[encoded] = $0.localizedDisplayName
            }
            UserDefaults.standard.set(list, forKey: "blocked")

        }
        
        store.shield.applicationCategories = appSelection.categoryTokens.isEmpty
        ? nil
        : ShieldSettings.ActivityCategoryPolicy.specific(appSelection.categoryTokens)

    }
    func onAppear() {
        appCount = store.shield.applications?.count ?? 0
        appSelection.applicationTokens = store.shield.applications ?? []
    }
    
  
}
