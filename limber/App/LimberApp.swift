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
import FirebaseCore

@main
struct LimberApp: App {
  private let di: AppDIContainer
  
  @AppStorage("hasSeenMain") var hasSeenMain: Bool = false
  @Environment(\.scenePhase) var scenePhase
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @StateObject var router: AppRouter = AppRouter()
  @StateObject var homeVM: HomeVM
  @StateObject var blockVM: BlockVM
  @StateObject var timerVM: TimerVM
  @StateObject var deviceActiveReportVM: DeviceActivityReportVM
  @StateObject var scheduleExVM: ScheduleExVM
  @StateObject var labVM: LabVM
  @StateObject var settingVM: SettingVM
  @StateObject var circularTimerVM: CircularTimerVM
  @StateObject var appBootStrapper: AppBootstrapper
  
  @State private var showSplash = true
  
  
  init() {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.systemPurple
    UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
    let di: AppDIContainer = AppDIContainer()
    self.di = di
    _homeVM = StateObject(wrappedValue: HomeVM())
    _blockVM = StateObject(wrappedValue: BlockVM() )
    _timerVM = StateObject(wrappedValue: TimerVM(timerRepository: di.timerRepo))
    _deviceActiveReportVM = StateObject(wrappedValue: DeviceActivityReportVM())
    _scheduleExVM = StateObject(wrappedValue: ScheduleExVM(timerRepository: di.timerRepo))
    _labVM = StateObject(wrappedValue: LabVM(historyRepo: di.timerHistoryRepo))
    _settingVM = StateObject(wrappedValue: SettingVM())
    _circularTimerVM = StateObject(wrappedValue: CircularTimerVM(historyRepo: di.timerHistoryRepo))
    _appBootStrapper = StateObject(wrappedValue: AppBootstrapper(timerRepo: di.timerRepo, timerHistoryRepo: di.timerHistoryRepo) )
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
              .onAppear {
                
              }
              .navigationDestination(for: SomeRoute.self) { route in
                switch route {
                case .home:
                  HomeView(homeVM: homeVM, deviceActivityReportVM: deviceActiveReportVM, bootstrapper: appBootStrapper)
                  
                case .main:
                  MainView(timerVM: timerVM, deviceActivityReportVM: deviceActiveReportVM, scheduleExVM: scheduleExVM, labVM: labVM, homeVM: homeVM, settingVM: settingVM)
                case .unlock:
                  let timerId = SharedData.defaultsGroup?.string(forKey: SharedData.Keys.nowTimerKey.key) ?? ""
                  UnlockReasonView(blockVM: blockVM, repo: di.timerRepo, timerId: timerId)
                case .circularTimer:
                  CircularTimerView(vm: circularTimerVM)
                    .toolbar(.hidden, for: .navigationBar)
                case .retrospective(let id, let historyId, let date, let focusType):
                  let vm = RetrospectiveVM(date: date, labName: focusType, timerId: id, historyId: historyId, repo: di.timerRetrospectRepo, appBootStrapper: appBootStrapper)
                  RetrospectiveView(vm: vm)
                case .focusTypes:
                  FocusTypesView()
                    .toolbar(.hidden, for: .navigationBar)
                case .unlockEndView:
                  UnlockEndView()
                case .limberLevelView:
                  LimberLevelView()
                    .toolbar(.hidden, for: .navigationBar)
                  
                }
              }
            
          }
          .environmentObject(appDelegate)
          .environmentObject(router)
          .environmentObject(blockVM)
          .environmentObject(appBootStrapper)
          .background(Color.white)
          .task { await appBootStrapper.run() }
          
          
        } else {
          OnBoardingView(onComplete: {
            hasSeenMain = true
            SharedData.defaultsGroup?.set(false, forKey: SharedData.Keys.doNotNoti.key)
          }, timerRepository: di.timerRepo)
          .task { await appBootStrapper.run() }
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
  @Published var isRunning = false
  
  private let timerRepo: TimerRepositoryProtocol
  private let timerHistoryRepo: TimerHistoryRepositoryProtocol
  
  init(timerRepo: TimerRepositoryProtocol, timerHistoryRepo: TimerHistoryRepositoryProtocol) {
    self.timerRepo = timerRepo
    self.timerHistoryRepo = timerHistoryRepo
  }
  
  func run() async {
    if isReady || isRunning {
      return
    }
    isRunning = true
    defer { isRunning = false }
    do {
      let deviceID = try await FirebaseAuthManager.shared.ensureSignedIn()
      SharedData.defaultsGroup?.set(deviceID, forKey: SharedData.Keys.UDID.key)
      if let historyRepo = timerHistoryRepo as? TimerHistoryRepository {
        do {
          try await historyRepo.flushPendingHistories()
        } catch {
          NSLog("pending history sync error: \(error)")
        }
      }
      
      async let timers = timerRepo.getUserTimers(userId: deviceID)
      async let histories = timerHistoryRepo.getHistoriesAll(
        .init(userId: deviceID, searchRange: "ALL", onlyIncompleteRetrospect: false)
      )
      
      
      let (timersVal, historiesVal) = try await (timers, histories)
      
      SharedData.defaultsGroup?.set(deviceID, forKey: SharedData.Keys.UDID.key)
      TimerSharedManager.shared.saveFocusSessions(timersVal)
      
      
      let models: [TimerModel] = historiesVal.map { history in
        let window = Self.actualWindow(
          historyDt: history.historyDt,
          startTime: history.startTime,
          endTime: history.endTime
        )
        return TimerModel(
          id: history.id,
          title: history.title,
          focusTitle: StaticValManager.titleDic[history.focusTypeId] ?? "기타",
          startTime: history.startTime,
          endTime: history.endTime,
          repeatDays: history.repeatDays,
          repeatCycleCode: RepeatCycleCode(rawValue: history.repeatCycleCode) ?? .NONE,
          actualDuration: window?.duration,
          historyTimestamp: window?.end.timeIntervalSince1970,
          actualStartTimestamp: window?.start.timeIntervalSince1970
        )
      }
      
      TimerSharedManager.shared.saveTimerModels(models)
      
      isReady = true
    } catch {
      NSLog("bootstrap error: \(error)")
      isReady = true
    }
  }

  private static func actualWindow(historyDt: String, startTime: String, endTime: String) -> (start: Date, end: Date, duration: TimeInterval)? {
    guard let endDate = parseHistoryDate(historyDt) else { return nil }
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    let baseDate = calendar.startOfDay(for: endDate)
    guard let start = combine(date: baseDate, time: startTime, zone: calendar.timeZone) else { return nil }
    let startMinutes = minutes(from: startTime) ?? 0
    let endMinutes = calendar.component(.hour, from: endDate) * 60 + calendar.component(.minute, from: endDate)
    var actualStart = start
    if endMinutes < startMinutes {
      actualStart = calendar.date(byAdding: .day, value: -1, to: actualStart) ?? actualStart
    }
    let duration = endDate.timeIntervalSince(actualStart)
    return duration >= 0 ? (start: actualStart, end: endDate, duration: duration) : nil
  }

  private static func parseHistoryDate(_ historyDt: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter.date(from: historyDt)
  }

  private static func combine(date: Date, time: String, zone: TimeZone) -> Date? {
    let parts = time.split(separator: ":").compactMap { Int($0) }
    guard parts.count >= 2 else { return nil }
    var cal = Calendar.current
    cal.timeZone = zone
    return cal.date(bySettingHour: parts[0], minute: parts[1], second: 0, of: date)
  }

  private static func minutes(from time: String) -> Int? {
    let parts = time.split(separator: ":").compactMap { Int($0) }
    guard parts.count >= 2 else { return nil }
    return parts[0] * 60 + parts[1]
  }
}
