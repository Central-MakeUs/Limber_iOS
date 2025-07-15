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
                        Text("6월 20일 학습 실험")
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
                        Slider(value: Binding(
                            get: { Double(selectedFocus) },
                            set: { selectedFocus = 50 == $0 ? 50 : 0 }
                        ), in: 0...100, step: 1)
                        .accentColor(Color.purple)
                        .frame(width: 260)
                        
                        if selectedFocus == 2 {
                            // 오른쪽 끝 100% 표시
                            Text("100%")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .offset(x: 36)
                        }
                    }
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

struct FocusExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        FocusExperimentView()
    }
}
