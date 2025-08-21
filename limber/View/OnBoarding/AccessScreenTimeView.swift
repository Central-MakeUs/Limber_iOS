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
      Spacer().frame(height: 40)

        VStack(spacing: 20) {
          Text("림버를 사용하려면\n다음의 데이터가 필요해요")
            .font(
              Font.suitHeading3
            )
            .multilineTextAlignment(.center)
          
          Text("권한에 동의해야 림버를 사용할 수 있어요")
            .font(
              Font.suitBody2
            )
            .foregroundStyle(.gray600)
          
          
          Spacer()
            .frame(height: 40)
          
          HStack(spacing: 0) {
            Image("phone_Fill_Color")
              .frame(width: 40, height: 40)
              .padding(.horizontal)
              .padding(.vertical, 19)
            VStack(alignment: .leading, spacing: 0) {
              Text("스크린 타임 데이터")
                .font(.suitHeading3Small)
                .foregroundStyle(Color.gray800)

              Text("앱 별 사용 시간 조회, 앱 차단 기능 제공")
                .foregroundStyle(Color.gray500)
                .font(.suitBody2)

            }
            Spacer()
          }.cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
              .inset(by: 0.5)
              .stroke(Color(red: 0.92, green: 0.9, blue: 0.93), lineWidth: 1)
            )

          
          HStack(spacing: 0) {
            Image("bell_Fill_Color")
              .frame(width: 40, height: 40)
              .padding(.horizontal)
              .padding(.vertical, 19)
            VStack(alignment: .leading, spacing: 0) {
              Text("알림 허용")
                .foregroundStyle(Color.gray800)
                .font(.suitHeading3Small)
              Text("푸시 알림 수신, 메시지 수신")
                .foregroundStyle(Color.gray500)
                .font(.suitBody2)
            }
   
            Spacer()
          }.cornerRadius(10)
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
        .onAppear {
          self.isAlert = false
        }
        .fullScreenCover(isPresented: $isAlert) {
          NotiAlertSheet(action: {
            self.step = 3
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







