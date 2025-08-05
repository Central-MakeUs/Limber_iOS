//
//  HomeVM.swift
//  limber
//
//  Created by 양승완 on 7/22/25.
//

import Foundation
import DeviceActivity
import SwiftUI
import ManagedSettings


class HomeVM: ObservableObject {
  
  @EnvironmentObject var router: AppRouter
  @Published var isTimering: Bool = false
  @Published var pickedApps: [PickedAppModel] = []
  @Published var startDate: Date?
  @Published var endDate: Date?
  @Published var nowDate: Date?

  
  func onAppear() {
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "ah시m분ss"
    
    
    let sessions =  FocusSessionManager.shared.loadFocusSessions()
    
    
    if let isTimering = SharedData.defaultsGroup?.bool(forKey: SharedData.Keys.isTimering.key) {
      self.isTimering = isTimering
    }
    if let data = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.pickedApps.key) {
      let decoder = JSONDecoder()
      if let apps = try? decoder.decode([PickedAppModel].self, from: data) {
        pickedApps = apps
      }
    }
    
  }
  
  
}
