//
//  CustomStepSlider.swift
//  limber
//
//  Created by 양승완 on 8/7/25.
//

import SwiftUI
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
