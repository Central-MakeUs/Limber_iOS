//
//  FocusStatsView.swift
//  limber
//
//  Created by 양승완 on 7/28/25.
//
import SwiftUI

struct LabView: View {
  
  @State var topPick = 0
  @State var btnEnable = false
  @State var showTooltip = false
  @State var buttonFrame: CGRect = CGRect()
  
  @ObservedObject var labVM: LabVM
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        ZStack(alignment: .top) {
          VStack {
            Spacer()
              .frame(height: 40)
            HStack(spacing: 4) {
              Text("림버의 실험실")
                .font(.suitHeading3)
              Button {
                showTooltip = true
              } label: {
                Image("icon!")
                  .frame(width: 20, height: 20)
              }
              .background(
                GeometryReader { geometry in
                  Color.clear
                    .onAppear {
                      buttonFrame = geometry.frame(in: .named("tooltipArea"))
                    }
                }
              )
              Spacer()
            }
            .padding(.horizontal)
            Spacer()
              .frame(height: 10)
            HStack(spacing: 0) {
              Button {
                topPick = 0
              } label: {
                Text("주간 리포트")
                  .tint(topPick == 0 ? .gray800 : .limberLightGray)
                  .font(.suitHeading3Small)
              }
              .frame(maxWidth: .infinity, maxHeight: 40)
              .overlay(
                Rectangle()
                  .frame(height: topPick == 0 ? 2: 1 )
                  .foregroundColor(topPick == 0 ? .limberPurple : .gray300), alignment: .bottom
              )
              
              Button {
                topPick = 1
              } label: {
                Text("실험 회고")
                  .tint(topPick == 1 ? .gray800 : .limberLightGray)
                  .font(.suitHeading3Small)
                
              }
              .frame(maxWidth: .infinity, maxHeight: 40)
              .overlay(
                Rectangle()
                  .frame(height: topPick == 1 ? 2: 1 )
                  .foregroundColor(topPick == 1 ? .limberPurple : .gray300), alignment: .bottom)
            }
          }
        }
        .background(
          Image("Lab_Background")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
          //
          //                    LinearGradient(
          //                        stops: [
          //                            Gradient.Stop(color: Color(red: 0.96, green: 0.92, blue: 1), location: 0.00),
          //                            Gradient.Stop(color: .white, location: 1.00),
          //                        ],
          //                        startPoint: UnitPoint(x: 0.5, y: 0),
          //                        endPoint: UnitPoint(x: 0.5, y: 1)
          //                    )
        )
        VStack(spacing: 0) {
          if topPick == 0 {
            ReportView(labVM: labVM)
            Spacer()
          } else {
            LookBackView(labVM: labVM)
            Spacer()
          }
        }
        .background(Color.gray50)
      }
      if showTooltip {
           Color.black.opacity(0.001)
               .ignoresSafeArea()
               .onTapGesture {
                   showTooltip = false
               }
       }
      if showTooltip {
        TooltipBubble(
          text: "실험실에서 집중 상태 측정을 연구토록\n활동을 학습할 수 있습니다.",
          buttonFrame: buttonFrame
        )
      }
    }
    .coordinateSpace(name: "tooltipArea")
    .onChange(of: topPick) {
      if topPick == 0 {
        Task {
          await labVM.fetchReports()
        }
      } else {
        labVM.fetchHistories()
      }
    
    }
  }
}
#Preview {
  LabView(labVM: LabVM())
}
