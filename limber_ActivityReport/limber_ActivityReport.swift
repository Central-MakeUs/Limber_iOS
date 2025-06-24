//
//  limber_ActivityReport.swift
//  limber_ActivityReport
//
//  Created by 양승완 on 6/23/25.
//

import DeviceActivity
import SwiftUI

@main
struct limber_ActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
