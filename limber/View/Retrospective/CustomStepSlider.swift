//
//  CustomStepSlider.swift
//  limber
//
//  Created by 양승완 on 8/7/25.
//

import SwiftUI
struct CustomStepSlider: View {
  
  @ObservedObject var vm: RetrospectiveVM
  
    let steps: [Double]
    var trackHeight: CGFloat = 8
    let stepImages: [String]
  @State private var previousValue: Int = 0
  @State private var showBubble = true


    private func nearestStepIndex(to rawValue: Double) -> Int {
        steps.enumerated().min(by: {
            abs($0.element - rawValue) < abs($1.element - rawValue)
        })?.offset ?? 0
    }

    var body: some View {
        GeometryReader { geo in
            let thumbSize: CGFloat = 22
            let availableWidth = geo.size.width - thumbSize
            let totalRange = steps.last! - steps.first!
          let percent = CGFloat((vm.value - steps.first!) / totalRange)
            let x = percent * availableWidth

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray)
                    .frame(height: trackHeight)

                Capsule()
                    .fill(Color.LimberPurple)
                    .frame(width: x + thumbSize / 2, height: trackHeight)

                ForEach(steps.indices, id: \.self) { i in
                    let step = steps[i]
                    let stepPercent = CGFloat((step - steps.first!) / totalRange)
                    let stepX = stepPercent * availableWidth
                    Circle()
                    .fill(vm.value >= step ? Color.LimberPurple : Color.gray)
                        .frame(width: thumbSize, height: thumbSize)
                        .offset(x: stepX)
                }

                Circle()
                    .fill(Color.white)
                    .overlay(Circle().stroke(Color.LimberPurple, lineWidth: 4))
                    .frame(width: thumbSize + 8, height: thumbSize + 8)
                    .offset(x: x)

              if showBubble, vm.currentIndex < stepImages.count {
                  Image(stepImages[vm.currentIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 40)
                        .offset(x: x - 10, y: -35)
                }
         
              
            
            }
            .frame(height: max(thumbSize, trackHeight))
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let loc = min(max(0, gesture.location.x - thumbSize / 2), availableWidth)
                        let rawPercent = Double(loc / availableWidth)
                        let rawValue = steps.first! + rawPercent * totalRange
                      vm.value = rawValue
                        showBubble = false
                    }
                  .onEnded { _ in
                    
                    let newIndex = nearestStepIndex(to: vm.value)

                    if newIndex != vm.currentIndex {
                        
                      if let anim = playTransitionAnimation(from: vm.currentIndex, to: newIndex) {
                        vm.transitionAnimationName = anim
                          }
                      vm.previousIndex = vm.currentIndex
                      vm.currentIndex = newIndex
                      }
                    vm.value = steps[newIndex]
                      showBubble = true
                  }
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 28) 
    }
  
  func playTransitionAnimation(from: Int, to: Int) -> String? {
      if from == 0 && to == 1 { return "20>60" }
      if from == 1 && to == 2 { return "60>100" }
      if from == 0 && to == 2 { return "20>100" }
      if from == 1 && to == 0 { return "60>20" }
      if from == 2 && to == 1 { return "100>60" }
      if from == 2 && to == 0 { return "100>20" }
      return nil
  }
}
#Preview {
  RetrospectiveView(vm: RetrospectiveVM(date: "", labName: "", timerId: 0, historyId: 0))
}

