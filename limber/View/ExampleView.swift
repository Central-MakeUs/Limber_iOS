//
//  TestView.swift
//  limber
//
//  Created by 양승완 on 6/30/25.
//
import SwiftUI
import ManagedSettings
import DeviceActivity


struct ExampleView: View {
    
    @State private var contextTotalActivity: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
                of: .day,
                for: .now
            ) ?? DateInterval()
        )
    )
    
    var body: some View {
        
        DeviceActivityReport(contextTotalActivity, filter: filter)
    }
    
}

struct ExampleTextLabel: View {
    @State private var contextListValues: DeviceActivityReport.Context = .init(rawValue: "Total Text")

    var body: some View {
        DeviceActivityReport(contextListValues)
    }
}

class ExampleVM: ObservableObject {
    var filter: DeviceActivityFilter = DeviceActivityFilter (
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    var pickedDate: Date = .now
    
    
}

