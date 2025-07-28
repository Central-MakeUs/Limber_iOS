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
    @EnvironmentObject private var appDelegate: AppDelegate
    @EnvironmentObject var router: AppRouter
    @ObservedObject var timerVM: TimerVM
    @ObservedObject var deviceActivityReportVM: DeviceActivityReportVM
    @ObservedObject var scheduleExVM: ScheduleExVM

    var body: some View {
            
            TabView(selection: $router.selectedTab) {
                HomeView(homeVM: HomeVM())
                    .tag(AppRouter.Tab.home)
                    .tabItem { Label("홈", image: "home") }
                TimerView(deviceReportActivityVM: deviceActivityReportVM, timerVM: timerVM, schedulExVM: scheduleExVM)
                    .tag(AppRouter.Tab.timer)
                    .tabItem { Label("타이머", image: "timer" )



                        
                    }
            
                SettingView()
                    .tag(AppRouter.Tab.more)
                    .tabItem { Label("더보기", image: "more") }
                
            }
            .tint(Color.primaryDark)
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
