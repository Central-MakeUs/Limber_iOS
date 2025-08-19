//
//  OnBoarding1View.swift
//  limber
//
//  Created by 양승완 on 6/30/25.
//

import SwiftUI
import FamilyControls

struct AccessScreenTimeView: View {
    @Binding var step: Int
    @EnvironmentObject var router: AppRouter
    @State var isEnable = true
    @State var isAlert = false
    var body: some View {
      ZStack {
   
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
            .frame(height: 40)
          
          HStack {
            Image(systemName: "phone")
              .padding()
            Text("스크린타임 데이터")
              .font(Font.custom("SUIT", size: 16)
                .weight(.semibold))
            Spacer()
          }.padding()
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
              .inset(by: 0.5)
              .stroke(Color(red: 0.92, green: 0.9, blue: 0.93), lineWidth: 1)
            )
          Spacer()
          BottomBtn(isEnable: $isEnable, title: "동의하고 시작하기" ) {
            Task {
              let status = await ScreenTimeManager.shared.requestPermission()
              ScreenTimeManager.shared.setStatus(status: status)
              if ScreenTimeManager.shared.currentStatus() == .approved {
                requestNotificationPermission()
              }
            }
          }
          .padding(.bottom, 24)
          
        }
      }
        .onAppear {
          self.isAlert = false
        }
        .fullScreenCover(isPresented: $isAlert) {
          NotiAlertSheet(action: {
            self.step = 1
          }, isAlert: $isAlert)
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
            .background(Color.black.opacity(0.3))
            .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            .ignoresSafeArea(.all)
        }
        .padding(.horizontal, 20)
        
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                Task {
                  await MainActor.run {
                      self.step = 3
                  }
                }
            } else {
              self.isAlert = true
            }
            if let error = error {
                print("알림 권한 요청 에러: \(error)")
            }
        }
    }
}







