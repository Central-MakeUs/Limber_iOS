//
//  BottomBtn.swift
//  limber
//
//  Created by 양승완 on 7/1/25.
//

import SwiftUI

struct bottomBtn: View {
    var body: some View {
        Text("동의하고 시작하기")
        .font(Font.custom("SUIT", size: 16)
        .weight(.semibold))
        .frame(width: 350, height: 54)
        .background(Color(red: 0.69, green: 0.35, blue: 0.96))
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}
