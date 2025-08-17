//
//  UnlockReasonView.swift
//  limber
//
//  Created by 양승완 on 7/16/25.
//

import Foundation
import SwiftUI
import ManagedSettings
import DeviceActivity

struct UnlockReasonView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var router: AppRouter
  
  @ObservedObject var blockVM: BlockVM
  
  @State var isSheet = false
  
 
  
  private let staticFailCodes: [String :String] = [FailReason.lackOfFocusIntention.rawValue :"LACK_OF_FOCUS_INTENTION", FailReason.needBreak.rawValue: "NEED_BREAK", FailReason.finishedEarly.rawValue: "FINISHED_EARLY", FailReason.emergency.rawValue: "EMERGENCY", FailReason.externalDisturbance.rawValue: "EXTERNAL_DISTURBANCE" ]
    

  
  
  @State var checkedReason: String = ""
  @State var isEnable: Bool = false
  
  var timerId: String
  
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Button {
          dismiss()
        } label: {
          Image("backBtn")
        }.padding(.leading)
        
        Spacer()
        
      }
      Spacer()
        .frame(height: 40)
      Text("잠금을 푸는 이유가 무엇인가요?")
        .font(.suitHeading2)
        .padding(.bottom)
      
      Text("잠금을 해제하는 순간 실험이 종료돼요")
        .font(.suitBody2)
        .foregroundStyle(.gray600)
      
      Spacer()
        .frame(height: 46)
      
      VStack(spacing: 12) {
        ForEach(Array(staticFailCodes.keys), id: \.self) { text in
          
          Button(action: {
            if checkedReason == text {
              checkedReason = ""
            } else {
              checkedReason = text
            }
            isEnable = !checkedReason.isEmpty
          }, label: {
            HStack(spacing: 0) {
              ZStack {
                Circle()
                  .fill(checkedReason == text ? Color.LimberPurple : Color.white)
                if checkedReason == text {
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
              .frame(width: 24, height: 24)
              .padding([.top, .leading, .bottom])
              .padding(.trailing, 12)
              
              Text("\(text)")
                .font(.suitBody1)
                .foregroundStyle(.gray800)
              
              Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .cornerRadius(10, corners: .allCorners)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(checkedReason == text ? .limberPurple : .gray300, lineWidth: 1)
            )
          })
          
        }
      }
      .padding(.horizontal, 20)
      
      Spacer()
      BottomBtn(isEnable: $isEnable, title: "잠금 풀기", action: {
        isSheet = true
      })
      .padding()
    }
    .toolbar(.hidden, for: .navigationBar)
    .fullScreenCover(isPresented: $isSheet ) {
      ReAskAlertSheet(leftAction: {
        let repo = TimerRepository()
        Task {
          let failReason = staticFailCodes[checkedReason] ?? "NONE"
          do {
            try await repo.unlockTimer(timerId: self.timerId, failReason: failReason)
            let deviceActivityCenter = DeviceActivityCenter()
            deviceActivityCenter.stopMonitoring()
            blockVM.removeForShieldRestrictions()
            isSheet = false
            router.push(.unlockEndView)
          } catch {
            print("error:::\(error)")
          }

        }
       
      }, rightAction: {
        router.poptoRoot()
      }, topText: "이대로 잠금을 풀면 실험이 종료돼요", bottomText: "실험을 중단할까요?", leftBtnText: "잠금 풀기", rightBtnText: "실험 유지하기")
      .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
      .background(Color.black.opacity(0.3))
      .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
      .ignoresSafeArea(.all)
    }
  }
}

struct UnlockEndView: View {
  @EnvironmentObject var router: AppRouter

  var body: some View {
    ZStack {
      VStack {
        Image("sadLimber")
          .resizable()
          .scaledToFit()
          .frame(width: 280, height: 280)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      // 2) 위쪽 텍스트
      VStack(spacing: 8) {
        Text("아쉽지만 실험을 중단했어요")
          .font(.suitHeading3)
        
        Text("충분한 여유를 가지고\n다음 집중 실험을 준비해봐요")
          .font(.suitBody2)
          .foregroundColor(.gray)
          .multilineTextAlignment(.center)
      }
      .padding(.top, 60)
      .frame(maxHeight: .infinity, alignment: .top)
      
      // 3) 아래쪽 버튼
      HStack(spacing: 12) {
        Button("화면 닫기") {
          router.poptoRoot()
        }
        .frame(maxWidth: .infinity, maxHeight: 54)
        .foregroundStyle(.gray800)
        .background(Color(.primayBGNormal))
        .cornerRadius(8)
        .font(.suitHeading3Small)
        
        Button("새 타이머 시작") {
          
          router.poptoRoot()
          router.selectedTab = .timer
          
        }
          .frame(maxWidth: .infinity, maxHeight: 54)
          .background(Color.limberPurple)
          .foregroundColor(.white)
          .cornerRadius(8)
          .font(.suitHeading3Small)
        
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 32)
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .background(Color.white)
    .toolbar(.hidden, for: .navigationBar)

  }
}
#Preview {
  UnlockEndView()
}
