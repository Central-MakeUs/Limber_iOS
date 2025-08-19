//
//  OnBoardingIndicatorView.swift
//  limber
//
//  Created by 양승완 on 8/18/25.
//

import SwiftUI


struct OnBoardingIndicatorView: View {

  @State private var selection = 0
  @Binding var step: Int
  
  let pages = ["Onboarding1", "Onboarding2", "Onboarding3"]
  let texts = ["집중에 방해되는\n도파민 앱을 선택하고", "타이머를 설정해\n집중 실험을 시작해요", "실험이 끝나면\n집중 기록을 확인해요"]
  
  var body: some View {
      VStack {
          TabView(selection: $selection) {
              ForEach(0..<pages.count, id: \.self) { index in
                VStack(spacing: 30) {
                  Image(pages[index])
                      .resizable()
                      .scaledToFill()
                      .frame(height: 480)
                      .frame(maxWidth: .infinity)
                      .clipped()
                      .tag(index)
                      
                  
                  
                  Text("\(texts[index])")
                    .font(.suitHeading3)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.black)
                      .padding(.bottom, 16)
                  Spacer()

                }
               
              }
          }
          .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
          
          Spacer()
          
 
        
        BottomBtn(
              isEnable: .constant(true),
              title: "확인했어요",
              action: {
                step += 1
              }
          )
          .padding(.horizontal, 20)
          .padding(.bottom, 24)
      }
  }
}

