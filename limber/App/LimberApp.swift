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
  @StateObject var router: AppRouter = AppRouter()
  @StateObject var homeVM = HomeVM()
  @StateObject var blockVM = BlockVM()
  @StateObject var timerVM = TimerVM()
  @StateObject var deviceActiveReportVM = DeviceActivityReportVM()
  @StateObject var scheduleExVM = ScheduleExVM()
  @StateObject var labVM = LabVM()
  @StateObject var settingVM = SettingVM()
  
  @State private var showSplash = true

  private var bootstrapper = AppBootstrapper()
  
  init() {
         UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.systemPurple  
         UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
     }
  
  var body: some Scene {
    WindowGroup {
      if showSplash {
        SplashView()
          .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              withAnimation {
                showSplash = false
              }
            }
          }
        
      } else {
        if hasSeenMain {
            NavigationStack(path: $router.path) {
              MainView(timerVM: timerVM, deviceActivityReportVM: deviceActiveReportVM, scheduleExVM: scheduleExVM, labVM: labVM, homeVM: homeVM, settingVM: settingVM)
                .task { await bootstrapper.run() }
                .navigationDestination(for: SomeRoute.self) { route in
                  switch route {
                  case .home:
                    HomeView(homeVM: homeVM, deviceActivityReportVM: deviceActiveReportVM)
                  case .main:
                    MainView(timerVM: timerVM, deviceActivityReportVM: deviceActiveReportVM, scheduleExVM: scheduleExVM, labVM: labVM, homeVM: homeVM, settingVM: settingVM)
                  case .unlock:
                    let timerId = SharedData.defaultsGroup?.string(forKey: SharedData.Keys.nowTimerKey.key) ?? ""
                    UnlockReasonView(blockVM: blockVM, timerId: timerId)
                  case .circularTimer:
                    CircularTimerView()
                      .toolbar(.hidden, for: .navigationBar)
                  case .retrospective(let id, let historyId, let date, let focusType):
                    let vm = RetrospectiveVM(date: date, labName: focusType, timerId: id, historyId: historyId)
                    RetrospectiveView(vm: vm)
                  case .focusTypes:
                    FocusTypesView()
                      .toolbar(.hidden, for: .navigationBar)
                  case .unlockEndView(let timerId):
                    UnlockEndView(timerId: timerId)
                  case .limberLevelView:
                    LimberLevelView()
                      .toolbar(.hidden, for: .navigationBar)

                  }
                }
              
            }
            .environmentObject(appDelegate)
            .environmentObject(router)
            .environmentObject(blockVM)
            .background(Color.white)
            
            
          } else {
            OnBoardingView(onComplete: {
              hasSeenMain = true
              SharedData.defaultsGroup?.set(false, forKey: "doNotNoti")
            })
            

          }
        }
    }
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
        if let view = appDelegate.currentViewId {
          router.push(view)
          appDelegate.currentViewId = nil
        }
        appDelegate.router = router
      }
      
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
 
    
    
  
}

@MainActor
final class AppBootstrapper: ObservableObject {
    @Published var isReady = false
  
    func run() async {
      
      let timerRepo = TimerRepository()
      let timerHistoryRepo = TimerHistoryRepository()
        do {
            let deviceID = try DeviceID.shared.getOrCreate()
          
            async let timers = timerRepo.getUserTimers(userId: deviceID)
            async let histories = timerHistoryRepo.getHistoriesAll(
                .init(userId: deviceID, searchRange: "ALL", onlyIncompleteRetrospect: false)
            )

          
            let (timersVal, historiesVal) = try await (timers, histories)

            SharedData.defaultsGroup?.set(deviceID, forKey: SharedData.Keys.UDID.key)
            TimerSharedManager.shared.saveFocusSessions(timersVal)

    
            let models: [TimerModel] = historiesVal.map {
                TimerModel(id: $0.id,
                           title: $0.title,
                           focusTitle: StaticValManager.titleDic[$0.focusTypeId] ?? "기타",
                           startTime: $0.startTime,
                           endTime: $0.endTime,
                           repeatDays: $0.repeatDays,
                           repeatCycleCode: RepeatCycleCode(rawValue: $0.repeatCycleCode) ?? .NONE)
            }
          
            TimerSharedManager.shared.saveTimerModels(models)

            isReady = true
        } catch {
            NSLog("bootstrap error: \(error)")
            isReady = true
        }
    }
}
