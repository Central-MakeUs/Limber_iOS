//
//  limberApp.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI
import FamilyControls

@main
struct LimberApp: App {
//    @AppStorage("hasSeenMain") var hasSeenMain: Bool = ScreenTimeManager.shared.latestStatus() == "approved"
    @AppStorage("hasSeenMain") var hasSeenMain: Bool = false
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            TimerView()
            //            if hasSeenMain {
//            if hasSeenMain {
//                NavigationStack(path: $router.path) { // ✅ 전역 네비게이션 스택
//                    MainView().navigationDestination(for: SomeRoute.self) { route in
//                        switch route {
//                        case .home:
//                            HomeView()
//                        case .laboratory:
//                            ContentView()
//                        case .more:
//                            ExampleView()
//                        case .timer:
//                            ExampleView()
//                        case .main:
//                            MainView()
//                        }
//                    }
//                }
//                .environmentObject(router)
//                .background(Color.white)
//                
//            } else {
//                OnBoardingView(onComplete: {
//                    hasSeenMain = true
//                    
//                })
//            }
            
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppRouter())
}
