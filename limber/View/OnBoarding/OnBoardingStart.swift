//
//  OnBoardingStart.swift
//  limber
//
//  Created by 양승완 on 8/18/25.
//

import SwiftUI


struct OnBoardingStart: View {
  
  @Binding var step: Int
  
  var body: some View {
    ZStack {
      Image("OnBoardingStart")
        .resizable()
        .ignoresSafeArea()
      
      VStack {
        Spacer()
        BottomBtn(isEnable: .constant(true), title: "집중 실험 알아보기" ) {
          step = 1
        }
        .padding([.horizontal] ,20)
        .padding(.bottom, 24)
        
      }
      
    }
  }
  
}
