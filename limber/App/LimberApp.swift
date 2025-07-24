//
//  limberApp.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings

@main
struct LimberApp: App {
    @AppStorage("hasSeenMain") var hasSeenMain: Bool = false
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var router = AppRouter()
    @StateObject var blockVM = BlockVM()
    @StateObject var contentVM = ContentVM()
    @StateObject var timerVM = TimerVM()
    @StateObject var deviceActiveReportVM = DeviceActivityReportVM()
    @StateObject var scheduleExVM = ScheduleExVM()
    @State var non = ""
    

    var body: some Scene {
        WindowGroup {
            
          if hasSeenMain {
                NavigationStack(path: $router.path) {
                    MainView(contentVM: contentVM, timerVM: timerVM, deviceActivityReportVM: deviceActiveReportVM, scheduleExVM: scheduleExVM)
                        .navigationDestination(for: SomeRoute.self) { route in
                        switch route {
                        case .home:
                            HomeView(homeVM: HomeVM())
                        case .main:
                            MainView(contentVM: contentVM, timerVM: timerVM, deviceActivityReportVM: deviceActiveReportVM, scheduleExVM: scheduleExVM)
                        case .unlock(let token):
                            UnlockReasonView(blockVM: blockVM, token: token)
                     
                        case .circularTimer(let hour):
                            CircularTimerView(hour: hour)
                        }
                    }
                    .environmentObject(appDelegate)
                 
                }
                .environmentObject(router)
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
            NSLog("scenePhase")
            if newPhase == .active {
                if let view = appDelegate.currentViewId {
                    router.push(view)
                    appDelegate.currentViewId = nil
                }
            }

        }
    
   
     
    
    }
}

