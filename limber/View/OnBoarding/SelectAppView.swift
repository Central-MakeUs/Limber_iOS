//
//  ContentView.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI
import FamilyControls

struct SelectAppView: View {
  @EnvironmentObject var vm: BlockVM
  @EnvironmentObject var router: AppRouter
  @State var onComplete: () -> Void
  @State var showPicker = false
  
  @State var isEnable = true
  
  var body: some View {

    ZStack {
      
      Image("Onboarding4")
        .resizable()
        .scaledToFit()
        .frame(maxWidth: .infinity)

      
      VStack(spacing: 20) {

        
        Text("집중을 방해하는 앱을\n등록해주세요")
          .font(
            Font.suitHeading3
          )
          .multilineTextAlignment(.center)
        
        Text("최대 10개의 앱을 등록할 수 있으며 언제든 변경 가능해요")
          .font(
            Font.suitBody2
          )
          .foregroundStyle(.gray600)
        
        Spacer()
        BottomBtn(isEnable: $isEnable, title: "앱 등록하기") {
          showPicker = true
        }
      
      }
    }.toolbar(.hidden, for: .navigationBar)
      .padding(20)
      .sheet(isPresented: $showPicker) {
        BlockBottomSheet(isOnboarding: true, vm: vm, onComplete: onComplete)
      }
      .presentationDetents([.height(700)])
      .background(
              RoundedRectangle(cornerRadius: 24)
                .fill(Color(.white))
          )
          .clipShape(RoundedRectangle(cornerRadius: 24))
    
  }
  
}


