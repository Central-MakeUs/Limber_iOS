//
//  CircleTimerVIew.swift
//  limber
//
//  Created by 양승완 on 7/15/25.
//

import Foundation
import SwiftUI

struct CircularTimerView: View {
    let totalTime: TimeInterval = 24 * 60 * 60 // 24시간 (예시)
    @State var elapsed: TimeInterval = 60 * 60 * 12 // 3시간 경과(예시)

    let gradient = AngularGradient(
        gradient: Gradient(colors: [.white, .white, .white, .limberPurple, .limberPurple, .limberPurple, .limberPurple ]),
        center: .center,
        startAngle: .degrees(0),
        endAngle: .degrees(360)
    )
    
    let backGradient = AngularGradient(
        gradient: Gradient(colors: [.primaryDark.opacity(0.2)]),
        center: .center,
        startAngle: .degrees(0),
        endAngle: .degrees(360)
    )
    
    var progress: Double {
        // 진행률 (0~1)
        elapsed / totalTime
    }
    
    var body: some View {
        ZStack {
            Color.limberPurple
                .ignoresSafeArea()
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image("xmark")
                    }
                    .frame(width: 24, height: 24)

                }
                .padding(.trailing, 20)
                
                Spacer()
                    .frame(height: 120)

                ZStack {
                  
                    // 배경 원
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 300, height: 300)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: .limberPurple, location: 0.00),
                                    Gradient.Stop(color: .primaryDark, location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                        )
                        .cornerRadius(300)
                        .padding(10)
                    
                    
                    
                    Circle()
                        .trim(from: 0, to: 360)
                        .stroke(backGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(gradient, style: StrokeStyle(lineWidth: 8, lineCap:
                                .round))
                        .rotationEffect(.degrees(-90))
                    
                    GeometryReader { geo in
                                  let size = min(geo.size.width, geo.size.height)
                                  let r = size/2
                                  let startAngle = Angle(degrees: -90)
                                  
                                  Circle()
                                      .fill(Color.white)
                                      .frame(width: 20, height: 8)
                                      .position(
                                          x: r + r * CGFloat(cos(startAngle.radians)),
                                          y: r + r * CGFloat(sin(startAngle.radians))
                                      )
                              }
                              .allowsHitTesting(false)
                    
                    GeometryReader { geo in
                        let size = min(geo.size.width, geo.size.height)
                        let radius = size / 2
                        let angle = Angle(degrees: -90 + (progress * 360))
                   
                        Image("star") // 별 이미지 넣기(Asset에 star 넣어야 함)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .position(
                                x: radius + radius * CGFloat(cos(angle.radians)),
                                y: radius + radius * CGFloat(sin(angle.radians))
                            )
                        
                   
                    }
                    .allowsHitTesting(false)
                    
                    VStack(spacing: 0) {
                        
                        Image("보류")
                            .resizable()
                            .frame(width: 125, height: 125)
                        Text(timeString(from: totalTime - elapsed))
                            .font(.suitDisplay1)
                            .foregroundColor(.white)
                    }
                }
                .padding(36)
                .clipShape(Circle())
                .frame(width: 280, height: 280)

                Spacer()
                    .frame(height: 54)
                HStack(spacing: 0) {
                    
                    Label(title: {
                        Text("학습")
                            .font(.suitHeading3Small)
                            .foregroundStyle(.limberPurple)
                    }, icon: {
                        Image("note")
                    })
     
                    Text("실험이 종료되었어요!")
                        .font(.suitHeading3Small)
                        .foregroundStyle(.white)
                }
                .frame(width: 220, height: 50)
                .background(Color.primaryDark)
                .cornerRadius(100, corners: .allCorners)

       
                
                Spacer()

                Button {
                    
                } label: {
                    HStack(spacing: 0) {
                        Text("차단 중인 앱 보기")
                            .font(.suitBody2)
                        Image("chevron")

                    }
                    .foregroundStyle(.gray300)
                }
                Spacer()
                    .frame(height: 30)
                
                Button {
                    
                } label: {
                    Text("홈으로 가기")
                        .font(.suitHeading3Small)
                }
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(.white)
                .cornerRadius(10, corners: .allCorners)
                .padding(.horizontal, 20)
                .padding(.bottom)
                
            }
            
            
        }
        
    
    }
    
    func timeString(from interval: TimeInterval) -> String {
        let hr = Int(interval) / 3600
        let min = (Int(interval) % 3600) / 60
        let sec = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hr, min, sec)
    }
}

struct CircularTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CircularTimerView()
    }
}
