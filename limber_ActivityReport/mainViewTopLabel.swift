//
//  mainViewTopLabel.swift
//  limber
//
//  Created by 양승완 on 8/21/25.
//

import SwiftUI
struct mainViewTopLabel: View {
  @State var text1: String
  @State var text2: String
  @State var labelType: Int = -1
  
  init(labelType: Int) {
    if labelType == 0 {
      text1 = "아직 활동"
      text2 = "이 없어요! 집중 활동부터 시작해볼까요?"
    } else if labelType == 1 {
      text1 = "집중 시간"
      text2 = "이 앞서고 있어요! 계속 이어나가요"
    } else {
      text1 = "도파민 노출"
      text2 = "이 과다해요! 집중을 더 늘려보아요"
    }
  }
  
  var body: some View {
    HStack(spacing: 0) {
      Spacer().frame(width: 12)
      Image( labelType == 0 ? "grayFire" : labelType == 1 ? "fire" : "dopamineIcon")
      
      Spacer()
        .frame(width: 2)
      
      Text(text1)
        .lineLimit(1)
        .foregroundStyle(labelType == 0 ? .gray700 : labelType == 1 ? .primaryVivid : Color(red: 1, green: 0.27, blue: 0.17))
        .font(.suitBody2)

      Text(text2)
        .lineLimit(1)
        .font(.suitBody2)
      
      Spacer().frame(width: 20)

    }
    .frame(height: 44)
  }
  
}
