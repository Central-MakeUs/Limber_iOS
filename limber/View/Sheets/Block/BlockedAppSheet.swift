//
//  BlockedAppSheet.swift
//  limber
//
//  Created by 양승완 on 8/21/25.
//

import SwiftUI


struct BlockedAppSheet: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject var blockVM: BlockVM
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 25)
      ZStack {
        Text("직접 추가")
          .font(.suitHeading3Small)
          .foregroundStyle(.gray800)
        HStack {
          Spacer()
          Button {
            dismiss()
          } label: {
            Image("xmark")
          }.padding(.trailing, 20)
        }
        
      }.frame(height: 33)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .center) {
          ForEach(blockVM.pickedApps, id: \.self) { app in
            if let token = app.token {
              VStack(spacing: 0) {
                Spacer()
                Label(token)
                  .labelStyle(iconLabelStyle())
                Label(token)
                  .labelStyle(textLabelStyle())
                  .scaleEffect(CGSize(width: 0.4, height: 0.4))
                Spacer()
              }
              .frame(width: 100, height: 76, alignment: .center)
              .background(Color.gray100)
              .cornerRadius(8)
              
            }
          }
        }
      }
      .frame(height: 76)
      .padding(20)
      
      Spacer()
    }
    .frame(maxHeight: 200)
  }
}
