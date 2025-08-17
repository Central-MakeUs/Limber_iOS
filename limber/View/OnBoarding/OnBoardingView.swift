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
  
  var body: some View {
    ZStack {
//      OnBoardingStartView()
      if step == 0 {
        AccessScreenTimeView(step: $step)
          .transition(.move(edge: .leading))
      }
      if step == 1 {
        SelectAppView(onComplete: onComplete).transition(.move(edge: .trailing))
          .environmentObject(BlockVM())
      }
      
    }
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


struct OnBoardingStartView : View {
  var body: some View {
    ZStack(alignment: .center) {
      Image("Start1")
      VStack(spacing: 0) {
        Spacer()
          .frame(height: 90)
        Text("안녕하세요")
        HStack(spacing: 0) {
         Text("집중을 도와줄")
          Text("림버")
            .foregroundStyle(Color.limberPurple)
          Text("에요!")
        }
       
        
        Spacer()
        
      }
      .font(.suitHeading1)
    }
   
  }
}

#Preview {
  OnBoardingStartView()
}
