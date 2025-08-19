//
//  WeeklyDataView.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//

import SwiftUI
import Charts
struct WeeklyDataView: View {
    @ObservedObject var labVM: LabVM
    
    var body: some View {
        VStack {
            Chart {
              ForEach( labVM.isImmersion ? labVM.immersionWeekly : labVM.focusTimeWeekly, id: \.day) { item in
                    BarMark(
                        x: .value("요일", item.day),
                        y: .value("값", item.value),
                        width: .fixed(24)
                    )
                    .foregroundStyle(Color.LimerLightPurple)
                    .cornerRadius(6)
                }
            }
            .chartYScale(domain: !labVM.isImmersion ? 0...24 : 0...100)
            .chartYAxis {
              AxisMarks(position: .leading, values: !labVM.isImmersion ? [0, 6, 12, 18, 24] : [0,20,40,60,80,100]) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(.gray.opacity(0.3))
                    AxisTick()
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                          Text(!labVM.isImmersion ? "\(intValue)h" : "\(intValue)%")
                                .font(.caption)
                                .foregroundColor(.gray400)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let stringValue = value.as(String.self) {
                            Text(stringValue)
                                .font(.caption)
                                .foregroundColor(.gray400)
                        }
                    }
                }
            }
            .frame(height: 200)
        }
    }
}
