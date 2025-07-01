//
//  RootView.swift
//  limber
//
//  Created by 양승완 on 7/1/25.
//

import SwiftUI
import FamilyControls

struct RootView: View {
//    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        let _ = print(AuthorizationCenter.shared.authorizationStatus)
        
        if ScreenTimeManager.shared.latestStatus() != "approved" {
            AccessScreenTimeView()
//                .environmentObject(router)
        } else {
            let _ = print("go main View")
            MainView()
//                .environmentObject(router)
        }
    }
    
}

//#Preview {
//    RootView()
//}
