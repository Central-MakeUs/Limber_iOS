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
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            Text("자동 키보드 올라오는 화면")
                .font(.headline)
            
            Spacer()
            
            TextField("입력하세요", text: $text)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .padding()
                .onChange(of: isFocused) { focused in
                    if !focused {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            isFocused = true
                        }
                    }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                isFocused = true
            }
            
        }
    }
}
