//
//  MainView.swift
//  limber
//
//  Created by 양승완 on 6/26/25.
//


import SwiftUI
import Combine


struct MainView: View {
  @EnvironmentObject private var appDelegate: AppDelegate
  @EnvironmentObject var router: AppRouter
  @EnvironmentObject var blockVM: BlockVM
  @ObservedObject var timerVM: TimerVM
  @ObservedObject var deviceActivityReportVM: DeviceActivityReportVM
  @ObservedObject var scheduleExVM: ScheduleExVM
  @ObservedObject var labVM: LabVM
  @ObservedObject var homeVM: HomeVM
  @ObservedObject var settingVM: SettingVM
  
  var body: some View {
    
    TabView(selection: $router.selectedTab) {
      HomeView(homeVM: homeVM, deviceActivityReportVM: deviceActivityReportVM)
        .tag(AppRouter.Tab.home)
        .tabItem { Label("홈", image: "home") }
      TimerView(deviceReportActivityVM: deviceActivityReportVM, timerVM: timerVM, schedulExVM: scheduleExVM)
        .tag(AppRouter.Tab.timer)
        .tabItem { Label("타이머", image: "timer" )}
      LabView(labVM: labVM)
        .tag(AppRouter.Tab.laboratory)
        .tabItem {Label("실험실", image: "laboratory")}
      SettingView(vm: settingVM)
        .tag(AppRouter.Tab.more)
        .tabItem { Label("더보기", image: "more") }
      
      
    }
    .tint(Color.primaryDark)
    .onAppear {
      
      let appearance = UITabBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = UIColor.white
      
      
      UITabBar.appearance().scrollEdgeAppearance = appearance

    }
    
    
    
    
  }
  
}
