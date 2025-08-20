//
//  MenuRow.swift
//  limber
//
//  Created by 양승완 on 8/1/25.
//

import SwiftUI

struct MenuRow: View {
  let title: String
  let hasChevron: Bool
  let isDestructive: Bool
  let onTap: () -> ()
  
  init(title: String, hasChevron: Bool, isDestructive: Bool = false, onTap: @escaping () -> ()) {
    self.title = title
    self.hasChevron = hasChevron
    self.isDestructive = isDestructive
    self.onTap = onTap
  }
  
  var body: some View {
    
    
    Button(action: {
      onTap()
    }) {
      VStack {
        Spacer()
        
        HStack {
          Text(title)
            .font(.system(size: 16))
            .foregroundColor(isDestructive ? .red : .primary)
          
          Spacer()
          if hasChevron {
            Image("chevron")
              .resizable()
              .frame(width: 24, height: 24)
              .foregroundStyle(Color.gray400)
            
          }
        }
        Spacer()
        Divider()
      }
      
      
    }
    .frame(height: 60)
    
    
  }
  
  
}
