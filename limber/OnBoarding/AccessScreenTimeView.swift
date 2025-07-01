//
//  OnBoarding1View.swift
//  limber
//
//  Created by 양승완 on 6/30/25.
//

import SwiftUI
import FamilyControls

struct AccessScreenTimeView: View {
    
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image("backBtn")
            }
            Spacer()
            
        }
        .padding()
        
        VStack() {
            
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
            
            BottomBtn(title: "동의하고 시작하기") {
                Task {
                    let status = await ScreenTimeManager.shared.requestPermission()
                    ScreenTimeManager.shared.setStatus(status: status)
                    if ScreenTimeManager.shared.currentStatus() == .approved {
                        router.push(.selectApp)
                    }
                }
            }
            Spacer()
                .frame(height: 10)
            
        }
        .padding(.horizontal)
        
    }
}


final class ScreenTimeManager {
    static let shared = ScreenTimeManager()

    private init() { }

    /// 스크린 타임 권한 요청 및 상태 반환
    func requestPermission() async -> String {
        let authCenter = AuthorizationCenter.shared

        do {
            try await authCenter.requestAuthorization(for: .individual)
        } catch {
            print("❌ 권한 요청 실패: \(error)")
            return "err"
        }

        try? await Task.sleep(nanoseconds: 500_000_000)

        let status = authCenter.authorizationStatus
        
        switch status {
        case .approved:
            return "approved"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        default:
            return ""
            
        }
        
        
    }

    /// 현재 상태만 가져오는 경우
    func currentStatus() -> AuthorizationStatus {
        return AuthorizationCenter.shared.authorizationStatus
    }
    
    func latestStatus() -> String {
        UserDefaults.standard.string(forKey: "screenTime") ?? ""
    }
    func setStatus(status: String) {
        UserDefaults.standard.set(status, forKey: "screenTime")

    }
}






#Preview {
    AccessScreenTimeView()
}
