//
//  OnBoarding1View.swift
//  limber
//
//  Created by 양승완 on 6/30/25.
//

import SwiftUI

struct AccessScreenTimeView: View {
    
    var body: some View {
        HStack {
            
            Button {
                
            } label: {
                //TODO: 이미지로 바꾸기
                Text("<")
                    .tint(Color.LimberLightGray)
            }
            Spacer()
        
        }
        .padding()
        
        VStack() {
            
            Spacer()
                .frame(height: 20)
            
            Text("림버를 사용하기 위해\n다음의 데이터가 필요해요")
            .font(
            Font.custom("SUIT", size: 24)
            .weight(.semibold)
            )
            .multilineTextAlignment(.center)
                
            
            Spacer()
                .frame(height: 20)
            
            Text("서비스 이용에 꼭 필요한 데이터만 수집해요")
            .font(
            Font.custom("SUIT", size: 14)
            .weight(.medium)
            )
            
            Spacer()
                .frame(height: 40)
            
            HStack {
                Image(systemName: "phone")
                    .padding()
                Text("스크린타임 데이터")
                .font(Font.custom("SUIT", size: 16)
                .weight(.semibold))
                Spacer()
            }.padding()
                .cornerRadius(10)
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(Color(red: 0.92, green: 0.9, blue: 0.93), lineWidth: 1)
                )
        
            
            Spacer()
            
            
            
            bottomBtn()
            Spacer()
                .frame(height: 10)
            
        }
        .padding(.horizontal)
    
    }
}







#Preview {
    AccessScreenTimeView()
}
