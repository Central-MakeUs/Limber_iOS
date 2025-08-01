//
//  DeviceActivityReportView.swift
//  limber
//
//  Created by 양승완 on 6/30/25.
//
import SwiftUI
import ManagedSettings
import DeviceActivity


class DeviceActivityReportVM: ObservableObject {
    
    @Published var contextTotalActivity: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
              of: .day,
                for: .now
            ) ?? DateInterval()
        )
    )

    var pickedDate: Date = .now
}
