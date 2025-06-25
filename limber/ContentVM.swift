//
//  ContentVM.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import FamilyControls
import Foundation
import ManagedSettings

class ContentVM: ObservableObject {
    
    let center = AuthorizationCenter.shared
    let store = ManagedSettingsStore()
    
    @Published var appSelection = FamilyActivitySelection(includeEntireCategory: true)
    
    func setShieldRestrictions() {
        store.shield.applications = appSelection.applicationTokens.isEmpty ? nil : appSelection.applicationTokens

        store.shield.applicationCategories = appSelection.categoryTokens.isEmpty
        ? nil
        : ShieldSettings.ActivityCategoryPolicy.specific(appSelection.categoryTokens)
    }
}
