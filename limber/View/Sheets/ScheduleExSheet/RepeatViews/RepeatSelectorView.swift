//
//  RepeatSelectorView.swift
//  limber
//
//  Created by 양승완 on 7/7/25.
//

import SwiftUI
struct RepeatSelectorView: View {
    @State private var selectedOption: String? = nil
    @State private var selectedDays: Set<String> = ["화"] // 예시로 화요일만 선택됨

    let repeatOptions = ["매일", "평일", "주말"]
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                ForEach(repeatOptions, id: \.self) { option in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(selectedOption == option ? Color.LimberPurple : Color.white)
                            if selectedOption == option {
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
                        selectedOption = option
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)

                
                }
            }

            
            
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.suitBody1)
                        .frame(width: 40, height: 40)
                        .background(selectedDays.contains(day) ? .limberPurple : .gray200)
                        .foregroundColor(selectedDays.contains(day) ? .white : .gray)
                        .clipShape(Circle())
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                        }
                    
                    
                }
            }
            .padding(.horizontal)
            
        }
        .padding(.vertical)
    }
}
