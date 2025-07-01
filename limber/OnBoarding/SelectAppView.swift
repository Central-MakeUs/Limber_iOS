//
//  ContentView.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI

struct SelecAppView: View {
    @EnvironmentObject var vm: SelectAppVM
    @State var showPicker = false
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image("backBtn")
            }
            Spacer()
            
        }
        .padding()
        
        VStack() {
            
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
                vm.setShieldRestrictions()
            }.padding()
        }
        

    }
    
    
}
#Preview {
    SelecAppView()
        .environmentObject(SelectAppVM())
}
