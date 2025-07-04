//
//  ContentView.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI
import FamilyControls

struct SelectAppView: View {
    @EnvironmentObject var vm: BlockVM
    @EnvironmentObject var router: AppRouter
    @State var onComplete: () -> Void
    @State var showPicker = false
    
    var body: some View {
        HStack {
            Button {
            } label: {
                Image("backBtn")
            }
            .padding(.leading)
            Spacer()
        }
        .padding()
        
        VStack {
            Spacer()
                .frame(height: 20)
            
            Text("림버를 통해\n관리할 앱을 등록해주세요")
                .font(
                    Font.suitHeading1
                )
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 20)
            
            Text("최대 10개의 앱을 등록할 수 있으며 추후에 변경할 수 있어요")
                .font(
                    Font.suitBody2
                )
            Spacer()
            
            BottomBtn(title: "앱 등록하기") {
                showPicker = true
            }.padding()
                .sheet(isPresented: $showPicker) {
                    BlockBottomSheet(vm: vm, onComplete: onComplete)
                }
                .presentationDetents([.height(700),])
                .presentationCornerRadius(24)
        }
        .toolbar(.hidden, for: .navigationBar)
  
    }
    
}


