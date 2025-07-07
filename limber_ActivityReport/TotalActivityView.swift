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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(activityReport.apps, id: \.self) { token in
                    Label(token)
                        .frame(width: 100, height: 76, alignment: .center)
                        .background(Color.gray100)
                        .cornerRadius(8)
    
                }
                .labelStyle(TrailingIconLabelStyle())
                .foregroundStyle(.black)

   


            }
        }
    }
}
struct TrailingIconLabelStyle: LabelStyle {
        
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 12)
            configuration.icon
            
            configuration.title
            Spacer()
                .frame(height: 12)
        }
    }
}
