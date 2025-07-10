//
//  AlertSheet.swift
//  limber
//
//  Created by 양승완 on 7/10/25.
//

import SwiftUI

struct AlertSheet: View {
    @ObservedObject var timerVM: TimerVM
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Spacer()
                    .frame(height: 32)
                Text("정말 삭제할까요?")
                    .font(.suitHeading3)
                    .foregroundStyle(.gray800)
                Text("삭제한 실험은 복구할 수 없어요.")
                    .font(.suitHeading3)
                    .foregroundStyle(.gray800)
                Spacer()
                HStack(spacing: 8) {
                    Button {
                        dismiss()
                    } label: {
                        Text("취소")
                            .font(.suitHeading3Small)
                    }
                    .foregroundStyle(.gray800)
                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                    .background(.gray200)
                    .cornerRadius(10)

                    
                    Button {
//                        timerVM.isDel()
                    } label: {
                        Text("삭제하기")
                            .font(.suitHeading3Small)
                    }
                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                    .background(.limberPurple)
                    .cornerRadius(10)

                }
                .foregroundStyle(.white)
                .frame(height: 54)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
                
                
            }
            .frame(height: 180)
            .cornerRadius(16)
            .padding(.horizontal, 20)
            Spacer()
            
        }
        .background(ClearBackground())

        
    }
    
}



