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
         TotalActivityReport { totalActivity in
             return TotalActivityView(activityReport: totalActivity)
         }
        
        TotalTextScene { totalText in
            return TotalActivityLabel(activityReport: totalText)
            
        }
        
     }
}




