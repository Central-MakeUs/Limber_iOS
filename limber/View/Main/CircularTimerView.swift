//
//  CircleTimerVIew.swift
//  limber
//
//  Created by 양승완 on 7/15/25.
//

import Foundation
import SwiftUI
import SwiftData

struct CircularTimerView: View {
  
  @Query var sessions: [FocusSession]
  @EnvironmentObject var router: AppRouter
  @Environment(\.dismiss) var dismiss

  @State var isFinished: Bool = false
  @EnvironmentObject var timer: TimerObserver

  
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
    
    timer.elapsed / timer.totalTime
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
            dismiss()
          }) {
            Image("xmark")
          }
          .frame(width: 24, height: 24)
          
        }
        .padding(.trailing, 20)
        
        Spacer()
          .frame(height: 120)
        
        ZStack {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 300, height: 300)
            .background(
              LinearGradient(
                stops: [
                  Gradient.Stop(color: .primaryDark, location: 0.00),
                  Gradient.Stop(color: .primaryMiddleDark, location: 0.6),
                  
                  Gradient.Stop(color: .white, location: 1.00),
                  
                ],
                startPoint: UnitPoint(x: 0, y: 0.7),
                endPoint: UnitPoint(x: 1.2, y: 0)
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
            
            Image("star")
              .resizable()
              .frame(width: 44, height: 44)
              .position(
                x: radius + radius * CGFloat(cos(angle.radians)),
                y: radius + radius * CGFloat(sin(angle.radians))
              )
          }
          .allowsHitTesting(false)
          
          VStack(spacing: 0) {
            
            Image("mainCharactor_1")
              .resizable()
              .frame(width: 125, height: 125)
            Text(TimeManager.shared
              .timeString(from: timer.totalTime - timer.elapsed))
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
          
          if isFinished {
            Text("실험이 종료되었어요!")
              .font(.suitHeading3Small)
              .foregroundStyle(.white)
          } else {
            Text("실험이 진행중이에요!")
              .font(.suitHeading3Small)
              .foregroundStyle(.white)
          }
          
        }
        .frame(width: 220, height: 50)
        .background(Color.primaryDark)
        .cornerRadius(100, corners: .allCorners)
        
        Spacer()
        
        //                Button {
        //
        //                } label: {
        //                    HStack(spacing: 0) {
        //                        Text("차단 중인 앱 보기")
        //                            .font(.suitBody2)
        //                        Image("chevron")
        //
        //                    }
        //                    .foregroundStyle(.gray300)
        //                }
        Spacer()
          .frame(height: 30)
        
        Button {
          router.poptoRoot()
        } label: {
          Text("홈으로 가기")
            .font(.suitHeading3Small)
            .foregroundStyle(Color.gray800)
        }
        .frame(maxWidth: .infinity, minHeight: 54)
        .background(.white)
        .cornerRadius(10, corners: .allCorners)
        .padding(.horizontal, 20)
        .padding(.bottom)
      }
      
    }
    
  }
  
}

struct CircularTimerView_Previews: PreviewProvider {
  static var previews: some View {
    CircularTimerView()
  }
}
