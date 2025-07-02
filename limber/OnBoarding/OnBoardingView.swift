//
//  OnBoarding1View.swift
//  limber
//
//  Created by 양승완 on 6/30/25.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var step: Int = 0
    @State var onComplete: () -> Void

       var body: some View {
           ZStack {
               if step == 0 {
                   AccessScreenTimeView(step: $step)
                       .transition(.move(edge: .leading))
               }
               if step == 1 {
                   SelectAppView(onComplete: $onComplete).transition(.move(edge: .trailing))
                       .environmentObject(SelectAppVM())
               }
           }
           .animation(.easeInOut, value: step)
       }
}

