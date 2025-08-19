//
//  SplashView.swift
//  limber
//
//  Created by 양승완 on 8/17/25.
//
import SwiftUI
struct SplashView: View {
//    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
          Image("Splash")
              .resizable()
              .scaledToFill()
              .opacity(opacity)
            .ignoresSafeArea()
            
       
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                opacity = 1.0
            }
        }
    }
}
