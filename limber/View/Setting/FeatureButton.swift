//
//  FeatureButton.swift
//  limber
//
//  Created by 양승완 on 8/1/25.
//

import SwiftUI

struct FeatureButton: View {
  let icon: String
  let title: String
  let action: () -> ()
  
  var body: some View {
    
    Button {
      action()
    } label: {
      VStack(spacing: 8) {
        Image(icon)
          .frame(width: 32, height: 32)
        
        Text(title)
          .font(.suitBody2)
          .foregroundColor(.gray800)
          .multilineTextAlignment(.center)
      }
    }
    .frame(maxWidth: .infinity)

  
  }
}
