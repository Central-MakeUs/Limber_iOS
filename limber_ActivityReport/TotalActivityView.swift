//
//  TotalActivityView.swift
//  limber_ActivityReport
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI
import ManagedSettings

struct TotalActivityView: View {
    var activityReport: ActivityReport
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading) {
                ForEach(
                    activityReport.apps.sorted { $0.duration > $1.duration }.prefix(3), id: \.id ) { eachApp in
                        ActivityRow(name: eachApp.displayName, time: eachApp.duration.toString(), icon: eachApp.token)
                    }
            }
            Spacer()
        }
    }
}
