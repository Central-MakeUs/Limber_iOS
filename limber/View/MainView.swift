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
    @StateObject var timerVM = TimerVM()
    @StateObject var exampleVM = ExampleVM()
    @StateObject var scheduleExVM = ScheduleExVM()

    var body: some View {
        TabView(selection: $router.selectedTab) {
            HomeView()
                .tag(AppRouter.Tab.home)
                .tabItem { Label("홈", image: "home") }
            TimerView(exampleVM: exampleVM, timerVM: timerVM, schedulExVM: scheduleExVM)
                .tag(AppRouter.Tab.timer)
                .tabItem { Label("타이머", image: "timer" ) }
//            BlockAppsSheet(vm: exampleVM, showModal: )
//                .tag(AppRouter.Tab.laboratory)
//                .tabItem { Label("실험실", image: "laboratory") }
            SettingView()
                .tag(AppRouter.Tab.more)
                .tabItem { Label("더보기", image: "more") }
        
        }
        .tint(Color.black)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        
    }
    
}
#Preview {
    MainView()
        .environmentObject(AppRouter())
}
