//
//  OnboardingIndicator.swift
//  limber
//
//  Created by 양승완 on 8/19/25.
//


import SwiftUI
struct OnboardingIndicator: View {
    let imageName: String
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.top, 20)   // 두 화면에서 동일하게
            .padding(.horizontal, 20)
    }
}
