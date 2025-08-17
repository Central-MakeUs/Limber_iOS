//
//  RetrospectiveVM.swift
//  limber
//
//  Created by 양승완 on 8/7/25.
//

import Foundation
import Combine
class RetrospectiveVM: ObservableObject {
  @Published var date: String
  @Published var labName: String
  @Published var focusDetail: String = ""
  @Published var isEnable: Bool = false
  @Published var selectedFocus: Int = 2
  @Published var sliderValue: Double = 0.5
  
  @Published var timerId: Int
  @Published var historyId: Int
  
  var api = TimerRetrospectAPI()
  
  init(date: String, labName: String, timerId: Int, historyId: Int) {
    self.date = date
    self.labName = labName
    self.timerId = timerId
    self.historyId = historyId
    
    $focusDetail
      .map { !$0.isEmpty }
      .assign(to: &$isEnable)
  }
  
  func save() {
    Task {
      do {
        var immersion = 50
        if sliderValue > 50 {
          immersion = 100
        } else if 50 > sliderValue {
          immersion = 20
        }
        
        if let deviceID = SharedData.defaultsGroup?.string(forKey: SharedData.Keys.UDID.key) {
          if let result = try await api.saveRetrospect(TimerRetrospectRequestDto(userId: deviceID, timerHistoryId: self.historyId, timerId: self.timerId, immersion: immersion, comment: focusDetail)) {
            
          }
          
        }
      } catch {
        print("cath \(error)")
      }
   
     
    }
 
  }
}
