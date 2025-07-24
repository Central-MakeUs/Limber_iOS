//
//  RepeatSelectorView.swift
//  limber
//
//  Created by 양승완 on 7/7/25.
//

import SwiftUI
struct RepeatSelectorView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: ScheduleExVM
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                ForEach(vm.repeatOptions, id: \.self) { option in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(vm.selectedOption == option ? Color.LimberPurple : Color.white)
                            if vm.selectedOption == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(Color.gray300, lineWidth: 1)
                        )
                        .contentShape(Circle())
                        
                        Text(option)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .onTapGesture {
                        if vm.selectedOption == option {
                            vm.selectedOption = nil
                        } else {
                            vm.selectedOption = option
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)

                
                }
            }

            
            
            HStack {
                ForEach(vm.weekdays, id: \.self) { day in
                    Text(day)
                        .font(.suitBody1)
                        .frame(width: 40, height: 40)
                        .background(vm.selectedDays.contains(day) ? .limberPurple : .gray200)
                        .foregroundColor(vm.selectedDays.contains(day) ? .white : .gray)
                        .clipShape(Circle())
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            if vm.selectedDays.contains(day) {
                                vm.selectedDays.remove(day)
                            } else {
                                vm.selectedDays.insert(day)
                            }
                        }
                }
            }
            .padding(.horizontal)
            
        }
        .padding(.vertical)
    }
}
