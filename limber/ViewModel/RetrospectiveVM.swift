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
  
  @Published var timerId: Int = 0
  @Published var historyId: Int = 0
  
  @Published var previousIndex: Int = 0
  @Published var currentIndex: Int = 0
  
  
  @Published var transitionAnimationName: String? = nil
  @Published var value: Double = 0.0
  
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

        var immersion = 0
        if currentIndex < 1 {
          immersion = 20
        } else if 2 > currentIndex {
          immersion = 60
        } else {
          immersion = 100
        }
        
        if let deviceID = SharedData.defaultsGroup?.string(forKey: SharedData.Keys.UDID.key) {
          if let _ = try await api.saveRetrospect(TimerRetrospectRequestDto(userId: deviceID, timerHistoryId: self.historyId, timerId: self.timerId, immersion: immersion, comment: focusDetail)) {
            let bootstrapper = await AppBootstrapper()
            await bootstrapper.run()
          }
          
        }
      } catch {
        print("cath \(error)")
      }
   
     
    }
 
  }
}
