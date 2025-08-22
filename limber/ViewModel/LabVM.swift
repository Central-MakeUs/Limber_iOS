//
//  LabVM.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//

import Foundation
@MainActor
class LabVM: ObservableObject {
  
  private let historyRepo = TimerHistoryRepository()
  private let repo = TimerHistoryAnalyticsAPI()
  private let userId = SharedData.defaultsGroup?.string(forKey: SharedData.Keys.UDID.key) ?? ""
  private var failReasonIcons = ["firstMedal", "secondMedal", "thirdMedal"]
  private var totalActualMinutes: Double = 1.0
  
  let convertDic = [
    "LACK_OF_FOCUS_INTENTION": FailReason.lackOfFocusIntention.rawValue,
    "NEED_BREAK": FailReason.needBreak.rawValue,
    "FINISHED_EARLY": FailReason.finishedEarly.rawValue,
    "EMERGENCY": FailReason.emergency.rawValue,
    "EXTERNAL_DISTURBANCE": FailReason.externalDisturbance.rawValue
  ]
  
  @Published var isImmersion = false
  
  
  
  @Published var focusTimeWeekly: [(day: String, value: Double)]
  @Published var immersionWeekly: [(day: String, value: Double)]
  
  
  
  @Published var histories: [TimerHistoryResponseDto] = []
  @Published var weekHistories: [TimerWeeklyHistoryResponseDto] = []
  
  @Published var studyData: [RankItem] = []
  @Published var reasonData: [RankItem] = []
  @Published var studyPer: Int = 0
  @Published var failPer: Int = 0
  
  @Published var firstReason: String = ""
  
  @Published var totalScheduledTimes: String = ""
  @Published var weeklyDate: String = ""
  @Published var averageAttentionTime: String = ""
  @Published var averageAttentionImmersion: String = ""
  @Published var totalFailureCount: Double = 0.0
  @Published var weekCount = 0
  
  @Published var isAll = true
  @Published var onlyNotComplete = false
  @Published var isChecked = false
  
  
  init() {
    focusTimeWeekly = [
      (day: "월", value: 0.0),
      (day: "화", value: 0.0),
      (day: "수", value: 0.0),
      (day: "목", value: 0.0),
      (day: "금", value: 0.0),
      (day: "토", value: 0.0),
      (day: "일", value: 0.0)
    ]
    immersionWeekly = [
      (day: "월", value: 0.0),
      (day: "화", value: 0.0),
      (day: "수", value: 0.0),
      (day: "목", value: 0.0),
      (day: "금", value: 0.0),
      (day: "토", value: 0.0),
      (day: "일", value: 0.0)
    ]
    
    self.fetchHistories()
    Task {
      await fetchReports()
    }
    
    
  }
  
  func onAppear() {
    Task {
      do {
          histories = try await historyRepo.getHistoriesAll(TimerHistorySearchDto(userId: userId, searchRange:  "ALL", onlyIncompleteRetrospect: self.isChecked))
          weekHistories = try await historyRepo.getHistoriesWeekly(TimerHistorySearchDto(userId: userId, searchRange: "WEEKLY", onlyIncompleteRetrospect: self.isChecked))
      } catch {
        print("error:::\(error)")
      }
      
    }
  }
  
  func fetchHistories() {
    Task {
      do {
        if self.isAll {
          histories = try await historyRepo.getHistoriesAll(TimerHistorySearchDto(userId: userId, searchRange:  "ALL", onlyIncompleteRetrospect: self.isChecked))
        } else {
          weekHistories = try await historyRepo.getHistoriesWeekly(TimerHistorySearchDto(userId: userId, searchRange: "WEEKLY", onlyIncompleteRetrospect: self.isChecked))
        }
 
  
      } catch {
        print("error:::\(error)")
      }
      
    }
  }
  
  
  func fetchReports() async {
    do {
      totalFailureCount = 0
      let startStr =  TimeManager.shared.weekStartString(for: .now, weekOffset: weekCount)
      let endStr =  TimeManager.shared.weekEndString(for: .now, weekOffset: weekCount)
      self.weeklyDate = TimeManager.shared.weekRangeString(for: .now, weekOffset: weekCount)

      focusTimeWeekly = [
        (day: "월", value: 0.0),
        (day: "화", value: 0.0),
        (day: "수", value: 0.0),
        (day: "목", value: 0.0),
        (day: "금", value: 0.0),
        (day: "토", value: 0.0),
        (day: "일", value: 0.0)
      ]
      immersionWeekly = [
        (day: "월", value: 0.0),
        (day: "화", value: 0.0),
        (day: "수", value: 0.0),
        (day: "목", value: 0.0),
        (day: "금", value: 0.0),
        (day: "토", value: 0.0),
        (day: "일", value: 0.0)
      ]
      

      
      
         let dto = try await repo.totalImmersion(.init(userId: userId, start: startStr, end: endStr)).data
         self.totalActualMinutes = Double(dto.totalActualMinutes)
         self.totalScheduledTimes =  TimeManager.shared.minutesToHourMinuteString(dto.totalActualMinutes)
         self.averageAttentionTime =  TimeManager.shared.minutesToHourMinuteString(dto.totalActualMinutes / 7)
         self.averageAttentionImmersion = (Int(dto.ratio * 100)).description + "%"
      
      
      let reasonData = try await repo.failReasons(.init(userId: userId, start: startStr, end: endStr)).data.sorted(by: { $0.count > $1.count }).enumerated().map { index, element in
        self.totalFailureCount += Double(element.count)
        return element
       }
    
      self.reasonData = reasonData.enumerated().prefix(3).map { index, element in
        let progress = Double(element.count) / (totalFailureCount)
        if index == 0 {
          self.failPer = Int(progress * 100)
          self.firstReason = convertDic[element.failReason] ?? ""
        }
        
        return RankItem(icon: failReasonIcons[index], title: convertDic[element.failReason] ?? "", duration: element.count.description + "회", progress: progress )
      }
      
      self.studyData  = try await repo.focusDistribution(.init(userId: userId, start: startStr, end: endStr)).data.sorted(by: { $0.totalActualMinutes > $1.totalActualMinutes }).prefix(3).enumerated().map { index, element in
        if index == 0 {
          self.studyPer = Int(Double(element.totalActualMinutes) / (self.totalActualMinutes == 0 ? 1 : self.totalActualMinutes) * 100)
        }
        
        return RankItem(icon: StaticValManager.titleDic[element.focusTypeId] ?? "", title: element.focusTypeName, duration: TimeManager.shared.minutesToHourMinuteString(element.totalActualMinutes), progress: Double(element.totalActualMinutes) / self.totalActualMinutes )  }
      
      
      try await repo.actualByWeekday(.init(userId: userId, start: startStr, end: endStr)).data.enumerated().forEach { index, element in
        self.focusTimeWeekly[index == 0 ? focusTimeWeekly.count - 1 : index - 1] = (day: element.dayOfWeek.convertToKor(), value: Double(element.totalActualMinutes) / 60 > 24 ? 24 : Double(element.totalActualMinutes) / 60)
      }
      
      try await repo.immersionByWeekday(.init(userId: userId, start: startStr, end: endStr)).data.enumerated().forEach { index, element in
        self.immersionWeekly[index == 0 ? immersionWeekly.count - 1 : index - 1] = (day: element.dayOfWeek.convertToKor(), value: Double(element.ratio) * 100)
        
        
      }
      
    } catch {
      print(error)
    }
  }

  

  
  func rightChevronTap() {
    if weekCount < 0 {
      Task {
        weekCount += 1
        await fetchReports()

      }
      
    }
  }
  func leftChevronTap() {
    Task {
      weekCount -= 1
      await fetchReports()

    }
    
  }
  
}



