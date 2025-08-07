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
  
  init(date: String, labName: String) {
    self.date = date
    self.labName = labName
    
    $focusDetail
      .map { !$0.isEmpty }
      .assign(to: &$isEnable)
  }
  
  func save() {
    
  }
}
