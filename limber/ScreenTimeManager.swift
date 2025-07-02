//
//  ScreenTimeManager.swift
//  limber
//
//  Created by 양승완 on 7/2/25.
//

import SwiftUI
import FamilyControls

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
 
