//
//  limber_ActivityReport.swift
//  limber_ActivityReport
//
//  Created by 양승완 on 6/23/25.
//

import DeviceActivity
import SwiftUI
import FirebaseCore

@main
struct limber_ActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        TotalActivityScene { totalActivity in
            let focus = totalActivity.focusTotalDuration.toMinute()
            let dopamine = totalActivity.totalDuration.toMinute()
            
            let total = focus + dopamine
            
            let dopaminePer = dopamine / total
            let focusPer = 1 - dopamine
            let focusTotalDuration = focus
            return TotalActivityView(activityReport: totalActivity, focusTotalDuration: focusTotalDuration, dopaminePer: dopaminePer, focusPer: focusPer)
        }
    }
}




