//
//  RootView.swift
//  limber
//
//  Created by 양승완 on 7/1/25.
//

import SwiftUI
import FamilyControls

struct RootView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        let _ = print(AuthorizationCenter.shared.authorizationStatus)
        if AuthorizationCenter.shared.authorizationStatus != .approved {
            AccessScreenTimeView()
                .environmentObject(router)
        } else {
            MainView()
                .environmentObject(router)
        }
    }
    
}

//#Preview {
//    RootView()
//}
