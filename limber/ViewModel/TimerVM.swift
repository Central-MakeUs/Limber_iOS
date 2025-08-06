//
//  TimerVM.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import Foundation
import SwiftUI
import Combine
import SwiftData

class TimerVM: ObservableObject {
  
  init() {
    $selectedCategory.map { !$0.isEmpty }
      .assign(to: &$btnEnable)
  }

  @Published var categorys: [String] = ["학습","업무","회의","직업","기타"]
  @Published var btnEnable = false
  @Published var isTimering = false
  
  
  
  @Published var selectingH: Int = 0
  @Published var selectingM: Int = 0
  @Published var selectedCategory: String = ""
  
  @Published var checkedModels: Set<FocusSession> = []
  
  @Published var timeSelect: [String] = ["시작", "종료", "반복"]
  @Published var allTime: [String] = [
    "오후 5시 36분",
    "오후 10시 32분",
    "2"]
  
  
  
  @Published var changeSheet = false
  @Published var bottomSheetTitle = "시작"
  @Published var isStartTime = false
  @Published var isTime = false
  
  @Published var isEdit = false
  @Published var isFin = false
  @Published var isAllChecker = false
  
  @Published var delAlert = false
  
  func focusCategoryTapped(idx: Int) {
    switch idx {
    case 0:
      isTime = true
      isStartTime = true
      bottomSheetTitle = "시작"
    case 1:
      isTime = true
      isStartTime = false
      bottomSheetTitle = "종료"
    default:
      isTime = false
      isStartTime = false
      bottomSheetTitle = ""
    }
    
    changeSheet = true
    
  }
  
  func reset() {
    changeSheet = false
    bottomSheetTitle = "시작"
    isStartTime = false
    isTime = false
  }
  
  
  
  func setDeleteSheet() {
      delAlert = !checkedModels.isEmpty
  }
  
  //    func deleteModels() {
  //        staticModels.enumerated().forEach { _,_ in
  //            if checkedModels.contains($0) {
  //                staticModels.remove
  //            }
  //        }
  //
  //    }
  
  func onAppear() {
    isTimering = SharedData.defaultsGroup?.bool(forKey: SharedData.Keys.isTimering.key) ?? false
  }
  
  
  
}
