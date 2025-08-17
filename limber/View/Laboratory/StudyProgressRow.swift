//
//  StudyProgressRow.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//

import SwiftUI
struct StudyProgressRow: View {
    let item: RankItem
    let colors: StudyColors
    
    var body: some View {
        HStack(spacing: 16) {
            Image(item.icon)
                .frame(width: 36, height: 36)
                .background(colors.color)
                .cornerRadius(18, corners: .allCorners)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(item.title)
                        .font(.suitBody2)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(item.duration)
                        .font(.suitBody3)
                        .foregroundColor(.gray600)
                }
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.primayBGNormal)
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colors.progressColor)
                            .frame(width: geometry.size.width * item.progress, height: 8)
                    }
                }
                .frame(height: 8)
            }
        }
    }
}
