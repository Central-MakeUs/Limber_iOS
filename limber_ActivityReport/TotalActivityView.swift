//
//  TotalActivityView.swift
//  limber_ActivityReport
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI
import ManagedSettings

struct TotalActivityView: View {
    
    @ObservedObject var vm: TotalActivityVM
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("집중한 시간")
                        .font(.suitBody2)
                        .foregroundColor(.limberPurple)
                    
                    Text(vm.focusTotalDuration.toString())
                        .font(.suitHeading2)
                        .frame( height: 30 )
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text("도파민 노출 시간")
                        .font(.suitBody2)
                        .foregroundColor(.limberOrange)
                    
                    HStack {
                        Spacer()
                        Text(vm.activityReport.totalDuration.toString())
                            .font(.suitHeading2)
                            .foregroundColor(.black)
                            .frame( height: 30 )
                    }
                        .frame(height: 30)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.limberPurple)
                        .frame(width: geometry.size.width * vm.focusPer - 0.001, height: 24)
                        .padding(.trailing, 1)
                    
                    Rectangle()
                        .fill(Color.limberOrange)
                        .frame(width: geometry.size.width * vm.dopaminePer - 0.001, height: 24)
                        .padding(.leading, 1)
                }
                .cornerRadius(12)
            }
            .frame(height: 24)
            .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 16)
            
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Circle().fill(Color.LimberPurple).frame(width: 8, height: 8)
                        Text("집중 활동")
                            .font(.suitBody2)
                            .foregroundStyle(Color.gray600)
                        Spacer()
                    }
                    .padding([.vertical, .leading])
                    
                    VStack {
                        VStack(alignment: .leading) {
                            
                            ForEach(
                                vm.focusTimeModels.sorted { $0.duration > $1.duration }.prefix(3), id: \.self ) { model in
                                    ActivityRow(name: model.name , time: model.duration.toString(), icon: nil)
                                }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .background(Color.gray200)
                .cornerRadius(10)
                .padding(.leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Circle().fill(Color.LimberOrange).frame(width: 8, height: 8)
                        Text("도파민 활동")
                            .font(.suitBody2)
                            .foregroundStyle(Color.gray600)
                        Spacer()
                        
                    }
                    .padding([.vertical, .leading])
                    
                    VStack {
                        VStack(alignment: .leading) {
                            ForEach(
                                vm.activityReport.apps.sorted { $0.duration > $1.duration }.prefix(3), id: \.id ) { eachApp in
                                    ActivityRow(name: eachApp.displayName, time: eachApp.duration.toString(), icon: eachApp.token)
                                }
                        }
                        Spacer()
                    }.padding(.horizontal)
                    
                }
                .background(Color.gray200)
                .cornerRadius(10)
                .padding(.trailing)
            }
            .frame(maxHeight: 140)
           
            
            Button {
                
            } label: {
                HStack(spacing: 0) {
                    Text("분석 더보기")
                        .foregroundStyle(.gray700)
                    Image("chevron")
                        .foregroundStyle(.gray300)
                }
                .font(.suitBody2)
            }
            .padding()
            
        }
        .background(Color.gray50)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        .onAppear {
            vm.getData()
        }
        
    }
}
