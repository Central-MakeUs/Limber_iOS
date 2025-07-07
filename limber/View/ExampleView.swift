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
    
    @ObservedObject var vm: ExampleVM
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
   
    var body: some View {
        VStack {
            Text("\(vm.pickedDate)")
            DeviceActivityReport(context, filter: vm.filter)
        }
       
    }
}



class ExampleVM: ObservableObject {
    @Published var filter: DeviceActivityFilter = DeviceActivityFilter (
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    @Published var pickedDate: Date = .now


}

