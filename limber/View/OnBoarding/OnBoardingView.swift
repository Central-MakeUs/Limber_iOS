//
//  OnBoarding1View.swift
//  limber
//
//  Created by 양승완 on 6/30/25.
//

import SwiftUI

struct OnBoardingView: View {
  @State private var step: Int = 0
  @State var onComplete: () -> Void
  @State private var page = 0
  @State private var showSplash = true
  
  var body: some View {
    ZStack {
      
      if step == 0 {
        OnBoardingStart(step: $step)
          .transition(
                     .asymmetric(
                      insertion: .move(edge: .trailing),
                      removal: .move(edge: .leading)
                     )
                 )
      }
      else if step == 1 {
        OnBoardingIndicatorView(step: $step)
      }
      else if step == 2 {
        VStack {
          OnboardingIndicator(imageName: "Indicator-2")

          AccessScreenTimeView(step: $step)
        }          .transition(
          .asymmetric(
           insertion: .move(edge: .trailing),
           removal: .move(edge: .leading)
          )
      )


      }
      else if step == 3 {
        VStack {
          OnboardingIndicator(imageName: "Indicator-2")

          SelectAppView(onComplete: onComplete)
        }  .transition(
          .asymmetric(
           insertion: .move(edge: .trailing),
           removal: .move(edge: .leading)
          )
      )
.environmentObject(BlockVM())
     
        
      }
      
      if showSplash {
        ZStack {
          Image("OnBoardingSplash")
            .resizable()
            .ignoresSafeArea()
            .transition(.opacity)
          
        }
        .transition(.opacity)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              withAnimation {
                showSplash = false
              }
            }
          }
      }
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .animation(.easeInOut, value: step)
    .onAppear {
      let timerRepository = TimerRepository()
      if let userId = SharedData.defaultsGroup?.string(forKey: SharedData.Keys.UDID.key) {
        Task {
          do {
            _ = try await timerRepository.getFetchAll(dto: TimerAllFetchStatusRequest(userId: userId, timerCode: "IMMEDIATE", status: "OFF"))
          } catch {
            print("error::: \(error)")
          }
          
        }
        
        
      }
    }
  }
  
}

