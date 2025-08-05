//
//  TotalActivityView.swift
//  limber_ActivityReport
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI
import ManagedSettings
import SwiftData
import FirebaseCore

struct TotalActivityView: View {
    var activityReport: ActivityReport
    var focusTotalDuration: TimeInterval
    var dopaminePer: Double
    var focusPer: Double
    
    init(activityReport: ActivityReport, focusTotalDuration: Double, dopaminePer: Double, focusPer: Double) {
        self.activityReport = activityReport
        self.focusTotalDuration = focusTotalDuration
        self.dopaminePer = dopaminePer
        self.focusPer = focusPer
    }
    var body: some View {
      ZStack {
        VStack(spacing: 16) {
          HStack {
            VStack(alignment: .leading, spacing: 6) {
              Text("집중한 시간")
                .font(.suitBody2)
                .foregroundColor(.limberPurple)
              
              Text(activityReport.focusTotalDuration.toString())
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
                Text(activityReport.totalDuration.toString())
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
                .frame(width: geometry.size.width * (1 - dopaminePer) - 0.001, height: 24)
                .padding(.trailing, 1)
              
              Rectangle()
                .fill(Color.limberOrange)
                .frame(width: geometry.size.width * dopaminePer - 0.001, height: 24)
                .padding(.leading, 1)
            }
            .cornerRadius(12)
          }
          .frame(height: 24)
          .padding(.horizontal, 24)
          
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
                    activityReport.focuses.sorted {  $0.totalDuration ?? 0.0 > $1.totalDuration ?? 0.0 }.prefix(3), id: \.id ) { model in
                      ActivityRow(name: model.focusTitle , time: (model.totalDuration ?? 0.0).toString(), icon: nil)
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
                    activityReport.apps.sorted { $0.duration > $1.duration }.prefix(3), id: \.id ) { eachApp in
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
          .padding(.vertical)
          //            Button {
          //
          //            } label: {
          //                HStack(spacing: 0) {
          //                    Text("분석 더보기")
          //                        .foregroundStyle(.gray700)
          //                    Image("chevron")
          //                        .foregroundStyle(.gray300)
          //                }
          //                .font(.suitBody2)
          //            }
          //            .padding()
          
        }
        .background(Color.gray50)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
      }
    }

}
