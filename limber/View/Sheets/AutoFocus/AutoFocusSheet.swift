//
//  AutoFocusTextFieldView.swift
//  limber
//
//  Created by 양승완 on 7/8/25.
//

import SwiftUI

struct AutoFocusSheet: View {
  @State private var text: String = ""
  @FocusState private var isFocused: Bool
  @State private var isEnable: Bool = false
  @Environment(\.dismiss) var dismiss
  

  var body: some View {
    VStack {
      
      Spacer()
        .frame(height: 30)
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
          }.padding(.trailing)
        }
        
      }.frame(height: 24)
      Spacer()
        .frame(height: 30)

      
      TextField("예약할 실험 타이머의 제목을 설정해주세요", text: $text)
        .focused($isFocused)
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(.gray300, lineWidth: 1)
        )
        .onChange(of: text) { newValue in
          isEnable = !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
      
      Spacer()
    }
    .hideKeyboardOnTap()
    .padding([.bottom, .horizontal], 20)
    .safeAreaInset(edge: .bottom) {
      BottomBtn(isEnable: $isEnable, title: "완료", action: {
        
      })
      .padding(20)

    }

  }
  
  //    var body: some View {
  //        VStack {
  //            Spacer()
  //                .frame(height: 20)
  //            Text("자동 키보드 올라오는 화면")
  //                .font(.headline)
  //
  //            Spacer()
  //
  //            TextField("입력하세요", text: $text)
  //                .textFieldStyle(.roundedBorder)
  //                .focused($isFocused)
  //                .padding()
  //                .onChange(of: isFocused) { _, focused in
  //                    if !focused {
  //                      isFocused = true
  //                    }
  //                }
  //        }
  //        .onAppear {
  //            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
  //                isFocused = true
  //            }
  //
  //        }
  //    }
}
