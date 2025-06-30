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
    
    @StateObject var vm = ExampleVM()

    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
   
    var body: some View {
        VStack {
            Text("\(vm.pickedDate)")
            DeviceActivityReport(context, filter: vm.filter)
            
            Button {
                vm.increaseDay()
            } label: {
                Text("Up")
            }
            
            Spacer().frame(height: 10)
            Button {
                vm.decreaseDay()
            } label: {
                Text("Down")
            }
        }
       
    }
}



class ExampleVM: ObservableObject {
    @Published var filter: DeviceActivityFilter
    @Published var pickedDate: Date = .now

    private var currentDate: Date {
        didSet {
            updateFilter()
        }
    }

    init() {
        self.currentDate = Date()
        self.filter = ExampleVM.makeFilter(for: currentDate)
    }

    func increaseDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        pickedDate = currentDate
    }

    func decreaseDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        pickedDate = currentDate
    }

    private func updateFilter() {
        self.filter = ExampleVM.makeFilter(for: currentDate)
    }

    private static func makeFilter(for date: Date) -> DeviceActivityFilter {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .day, for: date)!

        return DeviceActivityFilter(
            segment: .daily(during: interval),
            users: .all,
            devices: .init([.iPhone, .iPad])
        )
    }
}

#Preview {
    ExampleView()
}
