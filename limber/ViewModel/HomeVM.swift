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
  @Published var timerStr: String = ""
  @Published var pickedApps: [PickedAppModel] = []
  @Published var startDate: Date?
  @Published var endDate: Date?
  @Published var nowDate: Date?
  
  
  func onAppear() {
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "ah시m분ss"
    
    
    let sessions =  FocusSessionManager.shared.loadFocusSessions()
    let timeringName = SharedData.defaultsGroup?.string(forKey: SharedData.Keys.timeringName.key)
    
    var startTimeStr = ""
    var endTimeStr = ""
    
    sessions.forEach {
      if $0.uuid == timeringName {
        startTimeStr = $0.startTime
        endTimeStr = $0.endTime
      }
    }
    
    if let nowDate = TimeManager.shared.parseTimeString(formatter.string(from: .now)), let startDate = TimeManager.shared.parseTimeString(startTimeStr+"00") , let endDate = TimeManager.shared.parseTimeString(endTimeStr+"00") {
      
      if endDate < startDate {
        self.endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
      } else {
        self.endDate = endDate
      }
      let timeInterval = endDate.timeIntervalSince(nowDate)
      
      self.nowDate = nowDate
      self.startDate = startDate
      self.timerStr = timeInterval.toString()
    }
    
    
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
