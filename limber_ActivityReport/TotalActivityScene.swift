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
 
            
            let focuses = loadFocusSessions().map { FocusSession(name: $0.name, focusTitle: $0.focusTitle, startTime: $0.startTime, endTime: $0.endTime, repeatType: $0.repeatType, isOn: $0.isOn) }
            
            var focusTotalDuration = 0.0
            focuses.forEach {
                focusTotalDuration += $0.totalDuration ?? 0.0
            }
            return ActivityReport(totalDuration: totalActivityDuration, apps: sortedList, focusTotalDuration: focusTotalDuration, focuses: focuses)
        }
    
    
    //TODO: 불러올때 넣어줄떄 따로 파일로 뺴샘~
    func loadFocusSessions() -> [FocusSessionDTO] {
        if let data = SharedData.defaultsGroup?.data(forKey: "focusSessions") {
            let decoder = JSONDecoder()
            if let sessions = try? decoder.decode([FocusSessionDTO].self, from: data) {
                return sessions
            }
        }
        return []
    }
    
}
