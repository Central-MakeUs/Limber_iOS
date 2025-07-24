//
//  DeviceActivityReportVM.swift
//  limber
//
//  Created by 양승완 on 7/23/25.
//

import Foundation

struct FocusTimeModel: Hashable {
    
    var name: String
    var duration: TimeInterval
}

class TotalActivityVM: ObservableObject {
    
    @Published var activityReport: ActivityReport
    @Published var focusTimeModels: [FocusTimeModel] = [
        FocusTimeModel(name: "집중", duration: 0),
        FocusTimeModel(name: "집중", duration: 0),
        FocusTimeModel(name: "집중", duration: 0)
        
    ]
    
    @Published var focusTotalDuration: TimeInterval = 0
    
    @Published var focusPer: Double = 0
    @Published var dopaminePer: Double = 0
    
    
    init(activityReport: ActivityReport) {
        self.activityReport = activityReport
        
        getData()
    }
    
    
    func getData() {
        
        focusTimeModels.forEach {
            self.focusTotalDuration += $0.duration
        }
        let focus = focusTotalDuration.toMinute()
        let dopamine = activityReport.totalDuration.toMinute()
        
        let total = focus + dopamine
        
        dopaminePer = dopamine / total
        focusPer = 1 - dopaminePer

        NSLog("getData \(focusTimeModels) \(focusPer) \(dopaminePer)")
    }
    
}
