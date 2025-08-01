//
//  ReportView.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//

import SwiftUI
struct ReportView: View {
    
    @ObservedObject var labVM: LabVM
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 12)
                    Text("총 실험 시간")
                        .font(.suitBody2)
                        .foregroundColor(.gray600)
                    Text(labVM.totalTime)
                        .font(.suitHeading1)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Text(labVM.weeklyDate)
                            .font(.suitBody2)
                            .foregroundColor(.gray500)
                        
                        Spacer()
                    }
                }
                // 막대 그래프
                WeeklyDataView(labVM: labVM)
                
                HStack {
                    Spacer()
                    
                    SimpleToggle(leftText: "집중 시간", rightText: "몰입도 ", isOn: $labVM.toggleIsOn)
                    Spacer()
                }
                .padding(.bottom, 12)
                
                // 하단 통계 카드
                HStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Image("charts")
                                .frame(width: 36, height: 36)
                                .background(.white)
                                .cornerRadius(18, corners: .allCorners)
                            Text("평균 집중 시간")
                                .font(.suitBody2)
                                .foregroundColor(.primaryVivid)
                            
                            Text(labVM.averageAttentionTime)
                                .foregroundColor(.primaryDark)
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 132)
                    .background(.primayBGNormal)
                    .cornerRadius(10)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Image("fire")
                                .frame(width: 36, height: 36)
                                .background(.white)
                                .cornerRadius(18, corners: .allCorners)
                            
                            Text("평균 집중 몰입도")
                                .font(.suitBody2)
                                .foregroundColor(.primaryVivid)
                            
                            Text(labVM.averageAttentionImmersion)
                                .foregroundColor(.primaryDark)
                            
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 132)
                    .background(.primayBGNormal)
                    .cornerRadius(10)
                    
                }
            }
            .padding(20)
            Rectangle()
                .fill(Color.gray100)
                .frame(maxWidth: .infinity)
                .frame(height: 6)
            
            VStack(alignment: .leading, spacing: 20) {
                
                
                StudyInsightView(labVM: labVM)
                
                Spacer().frame(height: 12)
                
                StopReasonView(labVM: labVM)
                
            }
            .padding(.horizontal, 20)
            Spacer()
            
            
            
        }
    }
}
struct SegmentedToggle: View {
    @Binding var selectedIndex: Int
    private let titles = ["집중 시간", "몰입도"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<titles.count, id: \.self) { i in
                Text(titles[i])
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(selectedIndex == i ? .black : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedIndex = i
                        }
                    }
            }
        }
        .background(Color.gray.opacity(0.2))
        .clipShape(Capsule())
        .overlay(
            GeometryReader { proxy in
                let width = proxy.size.width / CGFloat(titles.count)
                RoundedRectangle(cornerRadius: (proxy.size.height-4)/2)
                    .fill(Color.white)
                    .frame(width: width-4, height: proxy.size.height-4)
                    .offset(x: CGFloat(selectedIndex) * width + 2)
                    .animation(.easeInOut, value: selectedIndex)
            }
                .padding(2)
        )
        .frame(height: 40)
    }
}
struct SimpleToggle: View {
    let leftText: String
    let rightText: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isOn = false
                }
            }) {
                Text(leftText)
                    .font(.suitBody2)
                    .foregroundColor(isOn ? .gray500 : .black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isOn ? Color.clear : Color.white)
                    )
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isOn = true
                }
            }) {
                Text(rightText)
                    .font(.suitBody2)
                    .foregroundColor(isOn ? .black : .gray500)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isOn ? Color.white : Color.clear)
                    )
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(Color(UIColor.gray200))
        )
        .frame(maxWidth: 196, maxHeight: 40)
    }
}
