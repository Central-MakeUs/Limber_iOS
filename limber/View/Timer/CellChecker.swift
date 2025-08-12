//
//  CellChecker.swift
//  limber
//
//  Created by 양승완 on 8/5/25.
//

import Foundation
import SwiftUI
struct CellChecker: View {
  @ObservedObject var timerVM: TimerVM
  
  let model: TimerResponseDto
  var action: () -> Void
  var body: some View {
    // 체크
    Button(action: {
      action()
    }, label: {
      ZStack {
        Circle()
          .fill(timerVM.checkedModels.contains(model) ? Color.LimberPurple : Color.white)
        if timerVM.checkedModels.contains(model) {
          Image(systemName: "checkmark")
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
