//
//  Untitled.swift
//  limber
//
//  Created by 양승완 on 7/7/25.
//

import SwiftUI
import Combine

struct RepeatView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var vm: ScheduleExVM
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      ZStack {
        
        HStack {
          Button {
            vm.goBack700H()
          } label: {
            Image("backBtn")
          }.padding(.leading)
          
          Spacer()
          
        }
        Text("반복 설정")
          .font(.suitHeading3Small)
          .foregroundStyle(.gray800)
        HStack {
          Spacer()
          Button {
            dismiss()
          } label: {
            Image("xmark")
          }.padding(.trailing, 20)
        }
        
      }.frame(height: 24)
      
      Spacer()
        .frame(height: 30)

      
      RepeatSelectorView(vm: vm)
      
      Spacer()
    }
    
    
  }
}
