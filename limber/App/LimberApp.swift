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
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) { // ✅ 전역 네비게이션 스택
                RootView().navigationDestination(for: SomeRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .laboratory:
                        ContentView()
                    case .more:
                        ExampleView()
                    case .timer:
                        ExampleView()
                    case .selectApp:
                        SelecAppView()
                            .environmentObject(SelectAppVM())
                    }
                }
            }
            .environmentObject(router)
            .background(Color.white)
           
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppRouter())
}
