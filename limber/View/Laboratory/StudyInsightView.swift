//
//  StudyInsightView.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//

import SwiftUI
struct StudyInsightView: View {
  
  @ObservedObject var labVM: LabVM
  
  let colors: [StudyColors] = [
    StudyColors(progressColor: Color.purple,
                color: Color.primayBGNormal),
    StudyColors(         progressColor: Color.colorPlatteSkyBlue,
                         color: Color.primayBGNormal),
    StudyColors(progressColor: Color.colorPlatteBlue,
                color: Color.primayBGNormal)
    
  ]
  
  
  var body: some View {
    
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
        .frame(height: 36)
      
      HStack {
        Text("실험 인사이트")
          .font(.suitHeading3Small)
          .foregroundColor(.gray500)
        Spacer()
      }
      .padding([.top, .bottom])
      
      VStack(alignment: .leading, spacing: 24) {
        VStack(alignment: .leading, spacing: 0) {
          Text("가장 몰입한 상황은")
            .font(.suitHeading2)
            .foregroundColor(.gray800)
          
          HStack(spacing: 0) {
            Text("학습")
              .font(.suitHeading2)
              .foregroundColor(.limberPurple)
            Text("이에요")
              .font(.suitHeading2)
              .foregroundColor(.gray800)
          }
          Spacer()
            .frame(height: 12)
          Text("전체 집중 시간의 50%를 차지했어요.")
            .font(.suitBody2)
            .foregroundColor(.gray700)
        }
        .padding([.horizontal, .top], 24)
        
        VStack(spacing: 20) {
          ForEach(Array(labVM.studyData.enumerated()), id: \.element.title) { idx, item in
            StudyProgressRow(item: item, colors: colors[idx])
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
}
