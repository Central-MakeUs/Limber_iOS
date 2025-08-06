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
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            
            Text("림버를 사용하기 위해\n다음의 데이터 허용이 필요해요.")
                .font(
                    Font.custom("SUIT", size: 24)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
            
            
            Spacer()
                .frame(height: 20)
            
            Text("서비스 이용에 꼭 필요한 데이터만 수집해요")
                .font(
                    Font.custom("SUIT", size: 14)
                        .weight(.medium)
                )
            
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
            .padding(20)

        }
        .padding(.horizontal)
        
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                Task {
                    await MainActor.run {
                        self.step = 1
                    }
                }
            } else {
                print("알림 권한 거부됨")
            }
            if let error = error {
                print("알림 권한 요청 에러: \(error)")
            }
        }
    }
}








