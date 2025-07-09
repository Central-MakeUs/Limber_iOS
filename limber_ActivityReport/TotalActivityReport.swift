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

extension DeviceActivityReport.Context {
    
    static let totalActivity = Self("Total Activity")
    static let barGraph = Self("barGraph")
    static let pieChart = Self("pieChart")
    
}

struct ActivityReport {
    let apps: [ApplicationToken]
}

//struct AppDeviceActivity: Identifiable {
//    var id: String
//    var displayName: String
//    var duration: TimeInterval
//    var numberOfPickups: Int
//    var token: ApplicationToken?
//}


struct TotalActivityReport: DeviceActivityReportScene {
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityReport {
        var tokens: [ApplicationToken] = [] /// 사용 앱 리스트

        let store = ManagedSettingsStore()
        let apps = store.shield.applications ?? []

        
        for token in apps {
            tokens.append(token)
        }
        
        return ActivityReport(apps: tokens)

    }
    
    // Define which context your scene will represent.
    /// 보여줄 리포트에 대한 컨텍스트를 정의해줍니다.
    let context: DeviceActivityReport.Context = .totalActivity
    
    // Define the custom configuration and the resulting view for this report.
    /// 어떤 데이터를 사용해서 어떤 뷰를 보여줄 지 정의해줍니다. (SwiftUI View)
    let content: (ActivityReport) -> TotalActivityView
    
    /// DeviceActivityResults 데이터를 받아서 필터링
//    func makeConfiguration(
//        representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityReport {
// 
//            var list: [AppDeviceActivity] = [] /// 사용 앱 리스트
//            for await eachData in data {
//                /// 특정 시간 간격 동안 사용자의 활동
//                for await activitySegment in eachData.activitySegments {
//                    /// 활동 세그먼트 동안 사용자의 카테고리 별 Device Activity
//                    for await categoryActivity in activitySegment.categories {
//                        /// 이 카테고리의 totalActivityDuration에 기여한 사용자의 application Activity
//                        for await applicationActivity in categoryActivity.applications {
//                            let appName = (applicationActivity.application.localizedDisplayName ?? "nil") /// 앱 이름
//                            let bundle = (applicationActivity.application.bundleIdentifier ?? "nil") /// 앱 번들id
//                            let duration = applicationActivity.totalActivityDuration /// 앱의 total activity 기간
//                            let numberOfPickups = applicationActivity.numberOfPickups
//                            
//                            if let token = applicationActivity.application.token {
//                                
//                                let appActivity = AppDeviceActivity(
//                                    id: bundle,
//                                    displayName: appName,
//                                    duration: duration,
//                                    numberOfPickups: numberOfPickups,
//                                    token: token
//                                )
//                                list.append(appActivity)
//                        }
//                        }
//                    }
//                    
//                }
//            }
//            
//            /// 필터링된 ActivityReport 데이터들을 반환
//            return ActivityReport(apps: list)
//        }
}
