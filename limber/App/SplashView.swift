//
//  SplashView.swift
//  limber
//
//  Created by 양승완 on 8/17/25.
//
import SwiftUI
struct SplashView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // 배경 그라데이션
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 157/255, green: 88/255, blue: 255/255),
                    Color(red: 208/255, green: 103/255, blue: 255/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
         
                
                Image("Splash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 340, height: 300)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
