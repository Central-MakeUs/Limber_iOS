//
//  BottomToast.swift
//  limber
//
//  Created by 양승완 on 8/2/25.
//

import SwiftUI


struct BottomToast: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    var iconName: String = "bell.fill"
    var iconColor: Color = .purple
    var backgroundColor: Color = Color.black.opacity(0.8)
    var textColor: Color = .white
    var cornerRadius: CGFloat = 12
    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 12

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                HStack(spacing: 8) {
                    Image(systemName: iconName)
                        .foregroundColor(iconColor)
                        .font(.system(size: 16, weight: .semibold))
                    Text(message)
                        .foregroundColor(textColor)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: isPresented)
            }
        }
    }

}
