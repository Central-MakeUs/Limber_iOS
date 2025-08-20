//
//  File.swift
//  limber
//
//  Created by 양승완 on 8/2/25.
//

import SwiftUI
//키보드 숨김관련
extension View {
  func hideKeyboardOnTap() -> some View {
    self.onTapGesture {
      unfocused()
    }
  }
  
  func unfocused() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil, from: nil, for: nil
    )
  }
}

extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape( RoundedCorner(radius: radius, corners: corners) )
  }
  
  func autoDismissOverlay<Overlay: View>(
    isPresented: Binding<Bool>,
    duration: TimeInterval = 2,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder overlay: @escaping () -> Overlay
  ) -> some View {
    self.modifier(AutoDismissOverlayModifier(isPresented: isPresented, duration: duration, overlay: overlay, onDismiss: onDismiss))
  }
}
struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

struct AutoDismissOverlayModifier<Overlay: View>: ViewModifier {
  @Binding var isPresented: Bool
  let duration: TimeInterval
  let overlay: () -> Overlay
  let onDismiss: (() -> Void)?
  func body(content: Content) -> some View {
    ZStack {
      content
      if isPresented {
        overlay()
          .transition(.opacity)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
              withAnimation {
                if let completion = onDismiss {
                  completion()
                }
                isPresented = false
              }
            }
          }
      }
    }
    .animation(.easeInOut, value: isPresented)
  }
  
}
