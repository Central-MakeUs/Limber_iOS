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
          }.padding(.trailing)
        }
        
      }.frame(height: 24)
      
      Spacer()
        .frame(height: 30)
      
      Text("반복할 주기를 선택해주세요")
        .foregroundStyle(.gray800)
        .font(.suitHeading3)
        .padding(.leading, 20)
      
      RepeatSelectorView(vm: vm)
      
      Spacer()
    }
    
    
  }
}
