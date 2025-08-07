//
//  FocusExperimentView.swift
//  limber
//
//  Created by 양승완 on 7/15/25.
//


import SwiftUI

class RetrospectiveVM: ObservableObject {
  @Published var date: String
  @Published var labName: String
  
  
  init(date: String, labName: String) {
    self.date = date
    self.labName = labName
  }
  
  func save() {
    
  }
}

struct RetrospectiveView: View {
  @Environment(\.dismiss) var dismiss
  
  @State private var selectedFocus: Int = 2
  @State private var focusDetail: String = ""
  @State private var isEnable: Bool = false
  @State private var sliderValue: Double = 0.5
  
  @StateObject var vm: RetrospectiveVM
  
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
          Text("\(vm.date) \(vm.labName)실험 회고")
            .font(.suitBody1)
            .foregroundColor(.gray400)
          
          HStack {
            Spacer()
            Button(action: {
              dismiss()
            }) {
              Image("xmark")
            }
            
          }
          .padding(.trailing, 20)
        }
        
        Spacer().frame(height: 50)

//        Text("작은 회고가 쌓여 나만의 집중 루틴을 만들어줄거예요")
//          .font(.suitBody3)
//          .foregroundColor(.limberPurple)
//          .frame(height: 29 )
//          .frame(maxWidth: .infinity)
//          .background(.primaryDark)
//          .cornerRadius(100, corners: .allCorners)
//          .padding(.horizontal, 55)
//        
//        Spacer()
//          .frame(height: 38)
        
        Text("이번 실험에 얼마나 몰입했나요?")
          .font(.suitHeading3)
          .foregroundColor(.white)
          .frame(height: 32)
        
        Spacer().frame(height: 40)

        
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
              .frame(width: 100)
            Spacer()
            Text("꽤 집중했어요")
              .frame(width: 100)
            Spacer()
            Text("완전 몰입했어요")
              .frame(width: 100)

          }
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.white.opacity(0.8))
          .frame(width: 340)
        }
        .padding(.bottom, 30)
        
        VStack {
          TextField("", text: $focusDetail, prompt: Text("오늘 집중한 활동을 간단히 기록해보세요")
            .font(.suitBody2)
            .foregroundStyle(Color.gray400), axis: .vertical)
          .font(.suitBody2)
          .foregroundStyle(Color.gray400)
          .lineLimit(3...6)
          .padding(20)
        }
        .background(.white.opacity(0.1))
        .cornerRadius(10)
        .padding(20)
        
        Spacer()
        
        Text("회고를 다 완성해야 저장할 수 있어요")
          .font(.suitBody2)
          .foregroundStyle(.gray500)
        
        BottomBtn(isEnable: $isEnable, title: "저장하기", action: {
          vm.save()
          dismiss()
          
        })
        .padding(20)
        
      }
    }
    .toolbar(.hidden, for: .navigationBar)
  }
    
}

//#Preview {
//  FocusExperimentView()
//}
//struct CustomStepSlider: View {
//  @Binding var value: Double
//  let steps: [Double]
//  var trackHeight: CGFloat = 8
//  
//  private func nearestStep(to rawValue: Double) -> Double {
//    steps.min(by: { abs($0 - rawValue) < abs($1 - rawValue) }) ?? rawValue
//  }
//  
//  var body: some View {
//    GeometryReader { geo in
//      let thumbSize: CGFloat = 22
//      let availableWidth = geo.size.width - thumbSize
//      let percent = CGFloat((value - steps.first!) / (steps.last! - steps.first!))
//      let x = percent * availableWidth
//      
//      ZStack(alignment: .leading) {
//        Capsule()
//          .fill(Color.gray)
//          .frame(height: trackHeight)
//        Capsule()
//          .fill(Color.LimberPurple)
//          .frame(width: x + thumbSize / 2, height: trackHeight)
//        ForEach(steps, id: \.self) { step in
//          
//          let stepPercent = CGFloat((step - steps.first!) / (steps.last! - steps.first!))
//          let stepX = stepPercent * availableWidth
//          let isActive = value >= step
//          
//          let circle = Circle()
//            .fill(isActive ? Color.LimberPurple : Color.gray)
//            .frame(width: thumbSize, height: thumbSize)
//            .offset(x: stepX)
//          circle
//          
//        }
//        Circle()
//          .fill(Color.white)
//          .overlay(Circle().stroke(Color.LimberPurple, lineWidth: 4))
//          .frame(width: thumbSize + 8, height: thumbSize + 8)
//          .offset(x: x)
//          .gesture(
//            DragGesture(minimumDistance: 0)
//              .onChanged { gesture in
//                let loc = min(max(0, gesture.location.x - thumbSize / 2), availableWidth)
//                let rawPercent = Double(loc / availableWidth)
//                let rawValue = steps.first! + rawPercent * (steps.last! - steps.first!)
//                value = nearestStep(to: rawValue) // snap
//              }
//              .onEnded { _ in
//                value = nearestStep(to: value) // 최종적으로도 snap
//              }
//          )
//      }
//      .frame(height: max(thumbSize, trackHeight))
//    }
//    .frame(maxWidth: .infinity)
//    .frame(height: max(28, trackHeight))
//    
//  }
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
            let totalRange = steps.last! - steps.first!
            let percent = CGFloat((value - steps.first!) / totalRange)
            let x = percent * availableWidth

            ZStack(alignment: .leading) {
                // 1) 트랙
                Capsule()
                    .fill(Color.gray)
                    .frame(height: trackHeight)
                Capsule()
                    .fill(Color.LimberPurple)
                    .frame(width: x + thumbSize / 2, height: trackHeight)

                // 2) 스텝 표시
                ForEach(steps, id: \.self) { step in
                    let stepPercent = CGFloat((step - steps.first!) / totalRange)
                    let stepX = stepPercent * availableWidth
                    Circle()
                        .fill(value >= step ? Color.LimberPurple : Color.gray)
                        .frame(width: thumbSize, height: thumbSize)
                        .offset(x: stepX)
                }

                // 3) 드래그 가능한 썸
                Circle()
                    .fill(Color.white)
                    .overlay(Circle().stroke(Color.LimberPurple, lineWidth: 4))
                    .frame(width: thumbSize + 8, height: thumbSize + 8)
                    .offset(x: x)
            }
            .frame(height: max(thumbSize, trackHeight))
            // 트랙 전체를 드래그 영역으로 지정
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        // 트랙 내에서 위치 계산
                        let loc = min(max(0, gesture.location.x - thumbSize / 2), availableWidth)
                        let rawPercent = Double(loc / availableWidth)
                        let rawValue = steps.first! + rawPercent * totalRange
                        value = nearestStep(to: rawValue)
                    }
                    .onEnded { _ in
                        value = nearestStep(to: value)
                    }
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: max(28, trackHeight))
    }
}

//#Preview {
//  RetrospectiveView(date: "3월2일", labName: "학습")
//}
