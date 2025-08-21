//
//  TimeSelectView.swift
//  limber
//
//  Created by 양승완 on 7/7/25.
//

import SwiftUI
struct TimeSelectView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: ScheduleExVM

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        vm.goBack700H()
                    } label: {
                        Image("backBtn")
                    }.padding(.leading)

                    Spacer()

                }
                Text("\(vm.bottomSheetTitle) 시간")
                    .font(.suitHeading3Small)
                    .foregroundStyle(.gray800)
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image("xmark")
                    }.padding(.trailing)
                }

            }.frame(height: 24)

            Spacer()
                .frame(height: 30)


            ZStack {
                Rectangle()
                    .frame(width: 320, height: 44)
                    .cornerRadius(10)
                    .foregroundStyle(
                        Color.gray200.opacity(0.6))

                VStack {
                    Spacer()
                    HStack {
                        HStack {
                            AmPmPickerWrapper(selectedRow: 0, selectedData: $vm.selectedAMPM)
                                .frame(width: 20, height: 20)
                            Spacer()
                                .frame(width: 30)
                            CustomTimePickerView(selectedHour: $vm.selectedHour, selectedMinute: $vm.selectedMinute, hourText: "시 ", hourRange: Array(0...12))
                                .frame(width: 200, height: 200)
                                .offset(x: -10)
                        }
                        .offset( x: 10, y: -2)
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: 200)
            Spacer()
        }
    }
}
//#Preview {
//    TimeSelectView(vm: ScheduleExVM())
//}
