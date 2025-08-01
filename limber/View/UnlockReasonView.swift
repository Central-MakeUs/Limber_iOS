//
//  UnlockReasonView.swift
//  limber
//
//  Created by 양승완 on 7/16/25.
//

import Foundation
import SwiftUI
import ManagedSettings

struct UnlockReasonView: View {
  @ObservedObject var blockVM: BlockVM
  
  private let staticModels: [String] = ["집중 의지가 부족해요","휴식이 필요해요","일정이 빨리 끝났어요","긴급한 상황이 발생했어요","외부의 방해가 있어요"]
  
  @Environment(\.dismiss) var dismiss
  @State var token: ApplicationToken
  
  @State var checkedModels: Set<String> = []
  @State var isEnable: Bool = false
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Button {
          dismiss()
        } label: {
          Image("backBtn")
        }.padding(.leading)
        
        Spacer()
        
      }
      Spacer()
        .frame(height: 40)
      Text("잠금을 푸는 이유가 무엇인가요?")
        .font(.suitHeading2)
        .padding(.bottom)
      
      Text("잠금을 해제하는 순간 실험이 종료돼요")
        .font(.suitBody2)
        .foregroundStyle(.gray600)
      
      Spacer()
        .frame(height: 46)
      
      VStack(spacing: 12) {
        ForEach(staticModels, id: \.self) { text in
          
          Button(action: {
            if checkedModels.contains(text) {
              checkedModels.remove(text)
            } else {
              checkedModels.insert(text)
            }
            isEnable = checkedModels.count > 0
          }, label: {
            HStack(spacing: 0) {
              ZStack {
                Circle()
                  .fill(checkedModels.contains(text) ? Color.LimberPurple : Color.white)
                if checkedModels.contains(text) {
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
              .frame(width: 24, height: 24)
              .padding([.top, .leading, .bottom])
              .padding(.trailing, 12)
              
              Text("\(text)")
                .font(.suitBody1)
                .foregroundStyle(.gray800)
              
              Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .cornerRadius(10, corners: .allCorners)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(checkedModels.contains(text) ? .limberPurple : .gray300, lineWidth: 1)
              
            )
            
            
          })
          
        }
      }
      .padding(.horizontal, 20)
      
      
      Spacer()
      BottomBtn(isEnable: $isEnable, title: "잠금 풀기", action: {
        blockVM.removeForShieldRestrictions(appToken: self.token)
        dismiss()
      })
      .padding()
    }
    .toolbar(.hidden, for: .navigationBar)
  }
}

//#Preview {
//    UnlockReasonView()
//}
