//
//  FocusExperimentView.swift
//  limber
//
//  Created by 양승완 on 7/15/25.
//


import SwiftUI

struct FocusExperimentView: View {
  @Environment(\.dismiss) var dismiss
  
  @State private var selectedFocus: Int = 2
  @State private var focusDetail: String = ""
  @State private var isEnable: Bool = false
  @State private var sliderValue: Double = 0.5
  @State private var date: String
  @State private var labName: String
  
  var body: some View {
    ZStack {
      
      Color.primaryDark
        .ignoresSafeArea()
      Image("background")
        .resizable()
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        // 상단 닫기 버튼
        ZStack(alignment: .center) {
          // 날짜
          Text("\(date) \(labName) 실험")
            .font(.suitBody1)
            .foregroundColor(.white)
          
          HStack {
            Spacer()
            Button(action: {
              
            }) {
              Image("xmark")
            }
            
          }
          .padding(.trailing, 20)
        }
        
        Spacer().frame(height: 22)
        
        Text("작은 회고가 쌓여 나만의 집중 루틴을 만들어줄거예요")
          .font(.suitBody3)
          .foregroundColor(.limberPurple)
          .frame(height: 29 )
          .frame(maxWidth: .infinity)
          .background(.primaryDark)
          .cornerRadius(100, corners: .allCorners)
          .padding(.horizontal, 55)
        
        Spacer()
          .frame(height: 38)
        
        Text("이번 실험, 얼마나 집중했나요?")
          .font(.system(size: 22, weight: .semibold))
          .foregroundColor(.white)
          .padding(.bottom, 28)
        
        
        Image("beaker")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 200, height: 200)
        
        Spacer()
          .frame(height: 62)
        
        // 슬라이더 + 값 표시
        VStack(spacing: 8) {
          ZStack(alignment: .trailing) {
            VStack {
              CustomStepSlider(
                value: $sliderValue,
                steps: [0, 50, 100], // 원하는 스텝 배열
                trackHeight: 8
              )
            }
            
//            if selectedFocus == 2 {
//              // 오른쪽 끝 100% 표시
//              Text("100%")
//                .font(.system(size: 14, weight: .bold))
//                .foregroundColor(.white)
//                .offset(x: 36)
//            }
          }
          .padding(.horizontal, 70)
          .padding(.vertical, 12)
          
          // 세 가지 선택 텍스트
          HStack {
            Text("거의 못했어요")
            Spacer()
            Text("꽤 집중했어요")
            Spacer()
            Text("완전 몰입했어요")
          }
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.white.opacity(0.8))
          .frame(width: 340)
        }
        .padding(.bottom, 30)
        
        TextField("구체적으로 어떤 일에 집중했나요?", text: $focusDetail)
          .frame(height: 90)
          .background(Color.white.opacity(0.1))
          .cornerRadius(10)
          .padding(.horizontal, 20)
          .font(.suitBody2)
        
        Spacer()
        
        BottomBtn(isEnable: $isEnable, title: "저장하기", action: {
          
          
        })
        .padding(20)
        
      }
    }
  }
}

//#Preview {
//  FocusExperimentView()
//}
struct CustomStepSlider: View {
  @Binding var value: Double
  let steps: [Double]
  var trackHeight: CGFloat = 8
  
  private func nearestStep(to rawValue: Double) -> Double {
    steps.min(by: { abs($0 - rawValue) < abs($1 - rawValue) }) ?? rawValue
  }
  
  var body: some View {
    GeometryReader { geo in
      let thumbSize: CGFloat = 22
      let availableWidth = geo.size.width - thumbSize
      let percent = CGFloat((value - steps.first!) / (steps.last! - steps.first!))
      let x = percent * availableWidth
      
      ZStack(alignment: .leading) {
        Capsule()
          .fill(Color.gray)
          .frame(height: trackHeight)
        Capsule()
          .fill(Color.LimberPurple)
          .frame(width: x + thumbSize / 2, height: trackHeight)
        ForEach(steps, id: \.self) { step in
          
          let stepPercent = CGFloat((step - steps.first!) / (steps.last! - steps.first!))
          let stepX = stepPercent * availableWidth
          let isActive = value >= step
          
          let circle = Circle()
            .fill(isActive ? Color.LimberPurple : Color.gray)
            .frame(width: thumbSize, height: thumbSize)
            .offset(x: stepX)
          circle
          
        }
        Circle()
          .fill(Color.white)
          .overlay(Circle().stroke(Color.LimberPurple, lineWidth: 4))
          .frame(width: thumbSize + 8, height: thumbSize + 8)
          .offset(x: x)
          .gesture(
            DragGesture(minimumDistance: 0)
              .onChanged { gesture in
                let loc = min(max(0, gesture.location.x - thumbSize / 2), availableWidth)
                let rawPercent = Double(loc / availableWidth)
                let rawValue = steps.first! + rawPercent * (steps.last! - steps.first!)
                value = nearestStep(to: rawValue) // snap
              }
              .onEnded { _ in
                value = nearestStep(to: value) // 최종적으로도 snap
              }
          )
      }
      .frame(height: max(thumbSize, trackHeight))
    }
    .frame(maxWidth: .infinity)
    .frame(height: max(28, trackHeight))
    
  }
}

