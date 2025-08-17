//
//  StopReasonView.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//

import SwiftUI
struct StopReasonView: View {
  
  @ObservedObject var labVM: LabVM
  
  let reasonColor = [
    StudyColors(progressColor: .primaryVivid, color: .primayBGNormal),
    StudyColors(progressColor: .limberPurple, color: .primayBGNormal),
    StudyColors(progressColor: .limerLightPurple, color:.primayBGNormal)
    
  ]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      VStack(alignment: .leading, spacing: 0) {
        Text("가장 많은 실험 중단 사유는")
          .font(.suitHeading2)
          .foregroundColor(.gray800)
        
        HStack(spacing: 0) {
          Text("\(labVM.firstReason)")
            .font(.suitHeading2)
            .foregroundColor(.limberPurple)
          Text("였어요")
            .font(.suitHeading2)
            .foregroundColor(.gray800)
        }
        Spacer()
          .frame(height: 12)
        Text("전체 중단 시간의 \(labVM.failPer)%를 차지했어요.")
          .font(.suitBody2)
          .foregroundColor(.gray700)
      }
      .padding([.horizontal, .top], 24)
      
      VStack(spacing: 24) {
        ForEach(Array(labVM.reasonData.enumerated()), id: \.element.title) { idx, item in
          StudyProgressRow(item: item, colors: reasonColor[idx])
        }
      }
      .padding([.horizontal, .bottom] ,24)
      .padding(.top, 16)
    }
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
    
    Spacer()
    
  }
}
