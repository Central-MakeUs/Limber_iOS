//
//  TotalActivityView.swift
//  limber_ActivityReport
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI
import ManagedSettings
import SwiftData

struct TotalActivityView: View {
  @State var activityReport: ActivityReport = .init(totalDuration: TimeInterval(), apps: [], focusTotalDuration: TimeInterval(), focuses: [])
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
      mainViewTopLabel(totalWin: activityReport.totalDuration > activityReport.focusTotalDuration)
        .background(  activityReport.totalDuration > activityReport.focusTotalDuration ? Color.lightYellow : Color.primayBGNormal)
        .cornerRadius(100)
      Spacer()
        .frame(height: 14)
      
        VStack(spacing: 12) {
          HStack {
            VStack(alignment: .leading, spacing: 6) {
              Text("집중한 시간")
                .font(.suitBody3)
                .foregroundColor(.gray600)
              
              Text(activityReport.focusTotalDuration.toString())
                .font(.suitHeading2)
                .frame( height: 30 )
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
              Text("도파민 노출 시간")
                .font(.suitBody3)
                .foregroundColor(.gray600)

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
          
          GeometryReader { geo in
            let p = min(max(dopaminePer, 0), 1)
            let leftW  = geo.size.width * (1 - p)
            let rightW = geo.size.width * p
            let hasLeft  = leftW  > 0.0
            let hasRight = rightW > 0.0

            HStack(spacing: (hasLeft && hasRight) ? 2 : 0) {
              if hasLeft {
                Color.limberPurple
                  .frame(width: leftW,  height: 24)
              }
              if hasRight {
                Color.limberOrange
                  .frame(width: rightW, height: 24)
              }
            }
            .frame(height: 24, alignment: .leading)
            .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
          }
          .frame(height: 24)
          .padding(.horizontal, 24)
          .padding(.bottom, 4)
          
          HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
              HStack {
                Circle().fill(Color.LimberPurple).frame(width: 8, height: 8)
                Text("집중 활동")
                  .font(.suitBody2)
                  .foregroundStyle(Color.gray600)
                Spacer()
              }
              .padding( .leading)
              .padding( .vertical, 18)
              
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
            .background(.gray100)
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 0) {
              HStack {
                Circle().fill(Color.LimberOrange).frame(width: 8, height: 8)
                Text("도파민 활동")
                  .font(.suitBody2)
                  .foregroundStyle(Color.gray600)
                Spacer()
              }
              .padding( .leading)
              .padding( .vertical, 18)
              
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
            .background(.gray100)
            .cornerRadius(10)
          }
          .frame(maxHeight: 160)
          .padding(.horizontal, 20)
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
          
          Spacer()

        }
        .background(Color.white)
        .cornerRadius(12)

    }

}
struct mainViewTopLabel: View {
  @State var text1: String
  @State var text2: String
  @State var totalWin: Bool
  
  init(totalWin: Bool) {
    self.totalWin = totalWin
    if !totalWin {
      text1 = "집중 시간"
      text2 = "이 앞서고 있어요! 계속 이어나가요"
    } else {
      text1 = "도파민 노출"
      text2 = "이 과다해요! 집중을 더 늘려보아요"
    }

  }
  
  var body: some View {
    HStack(spacing: 0) {
      Spacer()
        .frame(width: 12)
      Image( !totalWin ? "fire" : "dopamineIcon")
      Spacer()
        .frame(width: 6)
      
      Text(text1)
        .lineLimit(1)
        .foregroundStyle(totalWin ? Color(red: 1, green: 0.27, blue: 0.17) : .primaryVivid)
        .font(.suitBody2)

      Text(text2)
        .lineLimit(1)
        .font(.suitBody2)
      
      Spacer()
        .frame(width: 20)
    }
    .frame(maxWidth: 350)
    .frame(height: 44)
  }
  
}
