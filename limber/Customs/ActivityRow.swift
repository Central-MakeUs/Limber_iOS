//
//  ActivityRow.swift
//  limber
//
//  Created by 양승완 on 8/2/25.
//

import SwiftUI
import ManagedSettings

struct ActivityRow: View {
  let name: String
  let time: String
  let icon: ApplicationToken?
  
  var body: some View {
    HStack {
      if (icon != nil) {
        Label(icon!)
          .labelStyle(.iconOnly)
        Spacer()
          .frame(width: 16)
        
      } else {
        Text(name)
          .font(.suitCaption1)
          .foregroundStyle(Color.gray500)
        Spacer()
          .frame(width: 16)
      }
      
      Text(time)
        .font(.suitBody3)
        .foregroundColor(.gray400)
      Spacer()
    }
    .frame(height: 20)
  }
}
