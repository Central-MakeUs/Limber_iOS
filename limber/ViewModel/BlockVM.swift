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

struct PickedAppModel: Codable, Hashable, Equatable {
    static func == (lhs: PickedAppModel, rhs: PickedAppModel) -> Bool {
        return lhs.token == rhs.token
    }
    
    init(displayName: String, token: ApplicationToken?) {
        self.displayName = displayName
        self.token = token
    }
    var displayName: String
    let token: ApplicationToken?
}

extension ManagedSettingsStore.Name {
    static let total = Self("total")
}
extension DeviceActivityName {
    static let new = Self("new")
}

class BlockVM: ObservableObject {
    
    let store = ManagedSettingsStore(named: .total)
    
    @Published var appSelection = FamilyActivitySelection(includeEntireCategory: true)
    @Published var applicationTokens = Set<ApplicationToken>()
    @Published var pickedApps: [PickedAppModel] = []
    
    func setShieldRestrictions() {
//        store.shield.applications = appSelection.applicationTokens.isEmpty ? nil : appSelection.applicationTokens
        
        let models = appSelection.applications
            .map { PickedAppModel(displayName: $0.localizedDisplayName ?? "", token: $0.token)}
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(models) {
            SharedData.defaultsGroup?.set(data, forKey: SharedData.Keys.pickedApps.key)
        }
    }

    func removeForShieldRestrictions(appToken: ApplicationToken) {
      store.shield.applications = []
      SharedData.defaultsGroup?.set(nil, forKey: SharedData.Keys.isTimering.key)
      
      
      
      
      //tore.shield.applications?.filter { $0 != appToken }
      

      
      //        SharedData.defaultsGroup?.set(nil, forKey: SharedData.Keys.pickedApps.key)

    }
    
    func finishPick() {
        applicationTokens = appSelection.applicationTokens
        pickedApps = appSelection.applications.map { PickedAppModel(displayName: $0.localizedDisplayName ?? "", token: $0.token) }
    }
    
    func reset() {
        if let alreadyShield = store.shield.applications {
            appSelection.applicationTokens = alreadyShield
            applicationTokens = alreadyShield
        } else {
            setPicked()
        }
    }
    
    func setPicked() {
        if let data = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.pickedApps.key) {
            let decoder = JSONDecoder()
            if let apps = try? decoder.decode([PickedAppModel].self, from: data) {
                pickedApps = apps
                var set = Set<ApplicationToken>()
                apps.forEach {
                    if let token = $0.token {
                        set.insert(token)
                    }
                }
                self.appSelection.applicationTokens = set
            }
        }
    }
}
