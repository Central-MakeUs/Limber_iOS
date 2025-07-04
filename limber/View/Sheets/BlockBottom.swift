//
//  BlockBottomSheet.swift
//  limber
//
//  Created by 양승완 on 7/4/25.
//

import Foundation
import SwiftUI
import FamilyControls

struct BlockBottomSheet: View {
    @ObservedObject var vm: BlockVM
    @Environment(\.dismiss) private var dismiss
    @State var onComplete: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 20)
            HStack {
                Image("backBtn")
                Spacer()
                
                Button {
                    dismiss()
                    Task {
                        vm.setShieldRestrictions()
                        onComplete()
                    }
                    
                } label: {
                    Text("선택 완료")
                        .font(.suitBody2)
                        .foregroundStyle(Color.limberPurple)
                    
                }
                .disabled(vm.appSelection.applications.count > 10)

            }
            .padding(20)
            
            HStack {
                Text("관리할 앱을 최대 10개까지 등록해주세요")
                    .font(.suitHeading3)
                    .foregroundStyle(Color.gray800)
                Spacer()
            }
            .padding(.leading)
            .padding(.bottom, 6)
            
            HStack(spacing: 0) {
                Text("\(vm.appSelection.applications.count)")
                    .font(.suitHeading3Small)
                    .foregroundStyle(
                        vm.appSelection.applications.count == 0 ? Color.gray600
                      : vm.appSelection.applications.count > 10 ? Color.red
                      : Color.limberPurple
                    )
                    .padding(.leading, 12)
                Text("/10")
                    .font(.suitHeading3Small)
                    .foregroundStyle(Color.gray600)
                    .padding(.trailing, 12)
            }
            .frame(minWidth: 56, minHeight: 30)
            .fixedSize()
            .background(Color.limerLightPurple)
            .cornerRadius(100)
            .padding(.leading)
            Spacer()
                .frame(height: 16)
            
            FamilyActivityPicker(selection: $vm.appSelection)
        }
        
        
    }
}
