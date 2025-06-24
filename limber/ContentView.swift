//
//  ContentView.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: ContentVM
    @State var showPicker = false
    
    var body: some View {
        VStack{
            Text("선택 된 앱 개수 \(vm.appSelection.applicationTokens.count)")
            Text("선택 된 카테고리 개수 \(vm.appSelection.categoryTokens.count)")
            
            if (vm.appSelection.applicationTokens.count == 0) {
                Spacer()
                Text("선택 된 앱이 없습니다")
                Spacer()
            } else {
                List{
                    ForEach(Array(vm.appSelection.applicationTokens), id: \.self) { applicationToken in
                        ZStack (alignment: Alignment(horizontal: .leading, vertical: .center)){
                            HStack{
                                Label(applicationToken)
                                    .scaleEffect(CGSize(width: 0.95, height: 0.95))
                                Spacer()
                            }
                            Label(applicationToken)
                                .labelStyle(.iconOnly)
                                .scaleEffect(CGSize(width: 1.6, height: 1.6))
                        }
                        .frame(height: 50)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                }
                 .listStyle(.plain)
                 .listStyle(.grouped)
            }

            
            Button (action: {
                showPicker = true
            }) {
                Text("앱 선택하기")
            }.familyActivityPicker(isPresented: $showPicker, selection: $vm.appSelection)
                .onChange(of: showPicker) { newValue in
                    if newValue == false { // Picker가 닫히는 시점
                        Task {
                        vm.setShieldRestrictions()
                        }
                    }
                }
            
        }
    }
}

#Preview {
    @StateObject var vm = ContentVM()
    return ContentView().environmentObject(vm)
}
