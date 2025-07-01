//
//  BottomBtn.swift
//  limber
//
//  Created by 양승완 on 7/1/25.
//

import SwiftUI

struct BottomBtn: View {
    var title: String = "동의하고 시작하기"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Font.suit(.semiBold, size: 16))
                .frame(width: 350, height: 54)
                .background(Color(red: 0.69, green: 0.35, blue: 0.96))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
