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
        
         TotalActivityScene { totalActivity in
             let vm = TotalActivityVM(activityReport: totalActivity)
             return TotalActivityView(vm: vm)
         }
        
        
     }
}




