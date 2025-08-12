//
//  limberApp.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import _DeviceActivity_SwiftUI

@main
struct LimberApp: App {
  @AppStorage("hasSeenMain") var hasSeenMain: Bool = false
  @Environment(\.scenePhase) var scenePhase
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @StateObject private var router = AppRouter()
  @StateObject var homeVM = HomeVM()
  @StateObject var blockVM = BlockVM()
  @StateObject var timerVM = TimerVM()
  @StateObject var deviceActiveReportVM = DeviceActivityReportVM()
  @StateObject var scheduleExVM = ScheduleExVM()
  @StateObject var labVM = LabVM()
  @StateObject var settingVM = SettingVM()
  @StateObject var timerObserver = TimerObserver()
  
  var body: some Scene {
    WindowGroup {
      if hasSeenMain {
        NavigationStack(path: $router.path) {
          MainView(timerVM: timerVM, deviceActivityReportVM: deviceActiveReportVM, scheduleExVM: scheduleExVM, labVM: labVM, homeVM: homeVM, settingVM: settingVM)
            .navigationDestination(for: SomeRoute.self) { route in
              switch route {
              case .home:
                HomeView(homeVM: homeVM, deviceActivityReportVM: deviceActiveReportVM)
              case .main:
                MainView(timerVM: timerVM, deviceActivityReportVM: deviceActiveReportVM, scheduleExVM: scheduleExVM, labVM: labVM, homeVM: homeVM, settingVM: settingVM)
              case .unlock(let token):
                UnlockReasonView(blockVM: blockVM, token: token)
              case .circularTimer:
                CircularTimerView()
                  .toolbar(.hidden, for: .navigationBar)
              case .retrospective(let id):
                let dto = TimerSharedManager.shared.getFromId(timerSessionId: id)
                let date = TimeManager.shared.dateFormatter.string(from: .now)
                let labName = dto?.getFocusTitle() ?? ""
                let vm = RetrospectiveVM(date: date, labName: labName)
                RetrospectiveView(vm: vm)
                
              }
            }
            .environmentObject(appDelegate)
          
        }
        .environmentObject(router)
        .environmentObject(blockVM)
        .environmentObject(timerObserver)
        .background(Color.white)
        
        
      } else {
        OnBoardingView(onComplete: {
          hasSeenMain = true
          
        })
      }
      
      
    }
    //        .onChange(of: appDelegate.currentViewId) { _, view in
    //
    //            guard let view else {
    //                return
    //            }
    //            appDelegate.currentViewId = nil
    //            router.push(view)
    //
    //        }
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
        if let view = appDelegate.currentViewId {
          router.push(view)
          appDelegate.currentViewId = nil
        }
      }
      
    }
    
    
    
    
  }
}

