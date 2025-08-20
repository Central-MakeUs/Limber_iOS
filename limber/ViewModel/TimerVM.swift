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
import DeviceActivity

class TimerVM: ObservableObject {
  
  init() {
    $selectedCategory.map { !$0.isEmpty }
      .assign(to: &$btnEnable)
  }

  @Published var btnEnable = false
  @Published var isTimering = false
  
  @Published var selectingH: Int = 0
  @Published var selectingM: Int = 0
  @Published var selectedCategory: String = ""
  
  @Published var checkedModels: Set<TimerResponseDto> = []

  @Published var changeSheet = false
  @Published var bottomSheetTitle = "시작"
  @Published var isStartTime = false
  @Published var isTime = false
  
  @Published var isEdit = false
  @Published var isFin = false
  @Published var isAllChecker = false
  
  @Published var delAlert = false
  
  @Published var toastOn = false
  @Published var cantTommorowToast = false

  @Published var timers: [TimerResponseDto] = []
    
    var timerRepository = TimerRepository()
  
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
      let userId = SharedData.defaultsGroup?.string(forKey: SharedData.Keys.UDID.key) ?? ""
    Task { @MainActor [weak self] in
      guard let self else {return}
          do {
            timers = try await timerRepository.getUserTimers(userId: userId)
          } catch {
              
          }
      }
    isTimering = SharedData.defaultsGroup?.bool(forKey: SharedData.Keys.isTimering.key) ?? false
      
  }
  
  func nowStarting(completion: () -> ()) {
    if selectingH > 0 || (selectingH <= 0 && selectingM > 14) {
      completion()
    } else {
      if !toastOn {
        toastOn = true
      }
    }
  }
  
  
  func deleteTimers(action: () -> ()) async {
    let deviceActivityCenter = DeviceActivityCenter()
    do {
      for m in self.checkedModels {
        try await self.timerRepository.deleteTimer(id: m.id)
        deviceActivityCenter.stopMonitoring([.init(m.id.description)])
        TimerSharedManager.shared.deleteTimerSession(timerSessionId: m.id)
      }
    } catch {
      
    }
       await MainActor.run {
      delAlert = false
      isEdit = false
      action()
    }
  }
}
struct ToastModifier: ViewModifier {
  @Binding var isPresented: Bool
  let message: String
  let duration: TimeInterval
  
  let isWarning: Bool
  
  @State private var workItem: DispatchWorkItem?
  
  func body(content: Content) -> some View {
    ZStack {
      content
      
      if isPresented {
        VStack {
          Spacer()
          HStack(spacing: 8) {
            if isWarning {
              Image("warning")
                .frame(width: 20, height: 20)
            } else {
              Image("noti")
                .frame(width: 20, height: 20)
            }
            
            Text(message)
            
          }
          .padding()
          .background(Color.black.opacity(0.8))
          .foregroundColor(.white)
          .cornerRadius(10)
          .transition(.move(edge: .bottom).combined(with: .opacity))
          .padding(.bottom, 40)
          
        }
        .animation(.easeInOut, value: isPresented)
      }
    }
    .onChange(of: isPresented) { newValue in
      if newValue {
        workItem?.cancel()
        let task = DispatchWorkItem {
          withAnimation {
            isPresented = false
          }
        }
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
      }
    }
  }
}
