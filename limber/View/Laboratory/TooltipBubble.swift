//
//  TooltipBubble.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//

import SwiftUI
struct TooltipBubble: View {
    let text: String
    let buttonFrame: CGRect
    let tooltipSize = CGSize(width: 188, height: 58)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    Image("polygon")
                        .resizable()
                        .tint(.primaryVivid)
                        .frame(width: 11, height: 11)
                        .offset(y: -(tooltipSize.height / 2))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(text)
                        .font(.suitBody3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .frame(width: tooltipSize.width, height: tooltipSize.height)
                .background(Color.primaryVivid)
                .cornerRadius(4)
            }
            .fixedSize()
            .position(
                x: buttonFrame.midX,
                y: buttonFrame.maxY + (tooltipSize.height / 2) + 8
            )
        }
    }
}
