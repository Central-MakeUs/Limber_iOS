//
//  RetrospectEmptyView.swift
//  limber
//
//  Created by 양승완 on 8/14/25.
//

import SwiftUI

struct RetrospectEmptyView: View {
  
  @EnvironmentObject var router: AppRouter

  var body: some View {
    VStack(spacing: 24) {
      Spacer()
        .frame(height: 50)

      Image("EmptyNote")
        .frame(width: 200, height: 200)

      VStack(spacing: 8) {
        Text("아직 기록이 없어요.")
          .font(.suitBody2)
          .foregroundStyle(Color.gray600)

        Text("지금 바로 첫 실험을 시작해보세요!")
          .font(.suitBody2)
          .foregroundStyle(Color.gray600)
      }
      .multilineTextAlignment(.center)
      .padding(.horizontal, 24)

      Button(action: {
        router.selectedTab = .timer
      }) {
        Text("집중 시작하기")
          .font(.suitBody1)
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .foregroundStyle(Color.primaryVivid)
          .frame(maxWidth: 126, maxHeight: 42)
          .background(
            Capsule()
              .fill(Color.primayBGNormal)
          )
      }
      .buttonStyle(.plain)
      .padding(.horizontal, 32)
      .shadow(color: .black.opacity(0.05), radius: 8, y: 4)

      Spacer()
    }
    .padding(.vertical, 24)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(Color(.white))
  }
}

#Preview {
  RetrospectEmptyView()
}
