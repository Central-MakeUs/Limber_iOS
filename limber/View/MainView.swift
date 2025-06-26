//
//  HomeView.swift
//  limber
//
//  Created by 양승완 on 6/26/25.
//


import SwiftUI
import Combine

//#Preview {
//    MainView()
//}


struct MainView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject var contentVM = ContentVM()

    var body: some View {
        TabView(selection: $router.selectedTab) {
            HomeView()
                .tag(AppRouter.Tab.home)
                .tabItem { Label("홈", systemImage: "house") }
            ContentView()
                .environmentObject(contentVM)
                .tag(AppRouter.Tab.laboratory)
                .tabItem { Label("타이머", image: "timer") }
            SettingView()
                .tag(AppRouter.Tab.more)
                .tabItem { Label("더보기", image: "more") }
        
        }
        .tint(.tabBarDark)
    }
    
}
