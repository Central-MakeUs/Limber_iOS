//
//  File.swift
//  limber_ActivityReport
//
//  Created by 양승완 on 7/14/25.
//

import Foundation
import SwiftUI

struct TotalActivityLabel: View {
    var activityReport: ActivityReport
    var body: some View {
        HStack {
            Spacer()
            Text(activityReport.totalDuration.toString())
                .font(.suitHeading2)
                .foregroundColor(.black)
                .frame( height: 30 )
        
        }
      
    }
}

