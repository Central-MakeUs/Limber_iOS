//
//  TotalActivityReport.swift
//  limber_ActivityReport
//
//  Created by 양승완 on 6/23/25.
//

import DeviceActivity
import SwiftUI
import Foundation
import ManagedSettings
import SwiftData

struct TotalActivityScene: DeviceActivityReportScene {
  
  let context: DeviceActivityReport.Context = .totalActivity
  
  let content: (ActivityReport) -> TotalActivityView
  
  func makeConfiguration(
    representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityReport {
      var totalActivityDuration: Double = 0
      var list: [AppDeviceActivity] = []
      /// DeviceActivityResults 데이터에서 화면에 보여주기 위해 필요한 내용을 추출해줍니다.
      for await eachData in data {
        /// 특정 시간 간격 동안 사용자의 활동
        for await activitySegment in eachData.activitySegments {
          /// 활동 세그먼트 동안 사용자의 카테고리 별 Device Activity
          for await categoryActivity in activitySegment.categories {
            /// 이 카테고리의 totalActivityDuration에 기여한 사용자의 application Activity
            for await applicationActivity in categoryActivity.applications {
              let appName = (applicationActivity.application.localizedDisplayName ?? "nil")
              let bundle = (applicationActivity.application.bundleIdentifier ?? "nil")
              let numberOfPickups = applicationActivity.numberOfPickups
              let token = applicationActivity.application.token
              let duration = applicationActivity.totalActivityDuration
              
              let appActivity = AppDeviceActivity(
                id: bundle,
                displayName: appName,
                duration: duration,
                numberOfPickups: numberOfPickups,
                token: token
              )
              list.append(appActivity)
              
              totalActivityDuration += duration
            }
          }
          
        }
      }
      let sortedList = list.sorted { $0.duration > $1.duration }
      
      let focuses = FocusSessionManager.shared.loadFocusSessions().map { FocusSession(name: $0.title, focusTitle: "", startTime: $0.startTime, endTime: $0.endTime, repeatType: $0.repeatCycleCode.rawValue, isOn: $0.status == .running , days: $0.repeatDays) }
      
      var focusTotalDuration = 0.0
      focuses.forEach {
        focusTotalDuration += $0.totalDuration ?? 0.0
      }
      return ActivityReport(totalDuration: totalActivityDuration, apps: sortedList, focusTotalDuration: focusTotalDuration, focuses: focuses)
    }
}

struct BlockedScrollView: View {
  
  @State var pickedApps: [PickedAppModel]
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .center) {
        ForEach(pickedApps, id: \.self) { app in
          if let token = app.token {
            VStack {
              Label(token)
                .labelStyle(iconLabelStyle())
              Text("\(app.displayName)")
              //                                .scaleEffect(CGSize(width: 1.6, height: 1.6))
              //                            Text(app.displayName)
              //                                .foregroundStyle(Color.red)
              //
              //                            Label(app.displayName)
              //                                .labelStyle(textLabelStyle())
            }
            .cornerRadius(8)
            .frame(width: 100, height: 76, alignment: .center)
            .background(Color.gray100)
          }
        }
      }
    }
    .frame(height: 76)
    .padding([.bottom, .horizontal], 16)
  }
}


struct BlockedAppsScene: DeviceActivityReportScene {
  
  let context: DeviceActivityReport.Context = .blockedActivity
  
  let content: ([PickedAppModel]) -> BlockedScrollView
  
  
  func makeConfiguration(
    representing data: DeviceActivityResults<DeviceActivityData>) async -> [PickedAppModel] {
      
      var list: [PickedAppModel] = []
      
      if let data = SharedData.defaultsGroup?.data(forKey: SharedData.Keys.pickedApps.key) {
        let decoder = JSONDecoder()
        if let apps = try? decoder.decode([PickedAppModel].self, from: data) {
          list = apps
        }
        
      }
      let tokens = list.map { $0.token }
      /// DeviceActivityResults 데이터에서 화면에 보여주기 위해 필요한 내용을 추출해줍니다.
      for await eachData in data {
        for await activitySegment in eachData.activitySegments {
          for await categoryActivity in activitySegment.categories {
            for await applicationActivity in categoryActivity.applications {
              let appName = (applicationActivity.application.localizedDisplayName ?? "nil")
              guard let token = applicationActivity.application.token else { continue }
              if let index = tokens.firstIndex(of: token) {
                list[index].displayName = appName
              }
              
              
            }
          }
          
        }
      }
      
      return list
    }
  
  
}
