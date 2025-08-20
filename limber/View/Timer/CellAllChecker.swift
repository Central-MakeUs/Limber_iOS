//
//  CellAllChecker.swift
//  limber
//
//  Created by 양승완 on 8/5/25.
//

import SwiftUI
struct CellAllChecker: View {
  @ObservedObject var timerVM: TimerVM
  var action: () -> Void
  var body: some View {
    // 체크
    Button(action: {
      action()
    }, label: {
      ZStack {
        Circle()
          .fill(timerVM.isAllChecker ? Color.LimberPurple : Color.white)
        if timerVM.isAllChecker {
          Image("checkmark")
            .foregroundColor(.white)
        }
      }
      .frame(width: 24, height: 24)
      .overlay(
        Circle()
          .stroke(Color.gray300, lineWidth: 1)
      )
      .contentShape(Circle())
      .padding(8)
      
      
    })
    .frame(width: 24, height: 24)
    
    
    
  }
  
}
