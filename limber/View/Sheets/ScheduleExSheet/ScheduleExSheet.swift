//
//  BlockBottomSheet.swift
//  limber
//
//  Created by 양승완 on 7/4/25.
//

import Foundation
import SwiftUI

struct ScheduleExSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: ScheduleExVM
    
    
    @State var showSheet = false
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                if vm.changeSheet {
                    BottomSheet4320H(vm: vm)
                } else {
                    VStack {
                        Spacer()
                            .frame(height: 30)
                        ZStack {
                            Text("실험 예약하기")
                                .font(.suitHeading3Small)
                                .foregroundStyle(.gray800)
                            HStack {
                                Spacer()
                                Button {
                                    dismiss()
                                } label: {
                                    Image("xmark")
                                }.padding(.trailing)
                            }
                            
                        }.frame(height: 24)
                        Spacer()
                            .frame(height: 30)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("예약할 실험 타이머의 제목을 설정해주세요", text: $vm.textFieldName)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray300, lineWidth: 1)
                                )
                            
                            
                            Text("50자 이내로 입력해주세요.")
                                .font(.suitBody3)
                                .foregroundColor(.gray500)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 52)
                        
                        category
                            .padding(.bottom, 48)
                        
                        bottom
                        
                        Spacer()
                        
                        BottomBtn(isEnable: $vm.scheduleExBtnEnable, title: "예약하기", action: {
                            
                        })
                        .padding(20)
                        
                    }
                    
                    
                }
                
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.white)
        .cornerRadius(24)
        .hideKeyboardOnTap()
        
        
        
        
        
        
        
    }
    
    
    @ViewBuilder
    var category: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("무엇에 집중하고 싶으신가요?")
                    .font(.suitHeading3Small)
                
                
                Spacer()
            }
            .padding(.bottom, 20)
            ScrollView(.horizontal) {
                
                HStack(spacing: 8) {
                    ForEach(vm.categorys, id: \.self) { text in
                        Text(text)
                            .foregroundStyle(vm.selectedCategory == text ? Color.white : Color.gray500)
                            .frame(width: 68)
                            .frame(maxHeight: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke((vm.selectedCategory == text ? Color.LimberPurple : Color.gray300), lineWidth:
                                                vm.selectedCategory == text ? 2 : 1.2)
                            )
                            .background(vm.selectedCategory == text ? Color.LimberPurple : nil)
                            .cornerRadius(100)
                            .onTapGesture {
                                vm.selectedCategory = text
                            }
                    }
                    
                    //                    Label("직접추가", systemImage: "plus")
                    //                        .foregroundStyle(Color.gray500)
                    //                        .frame(width: 112)
                    //                        .frame(maxHeight: .infinity)
                    //                        .background(Color.gray200)
                    //                        .cornerRadius(100)
                    //                        .onTapGesture {
                    //                            showSheet = true
                    //                        }
                    //                        .sheet(isPresented: $showSheet) {
                    //                            AutoFocusSheet()
                    //                                .presentationDetents([.height(700), ])
                    //                                .presentationCornerRadius(24)
                    //                                .interactiveDismissDisabled(true)
                    //
                    //                        }
                }
            }
            .frame(height: 38)
            
            
        }
        .padding(.horizontal, 20)
        
    }
    
    @ViewBuilder
    var bottom: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("얼마동안 집중하시겠어요?")
                .font(.suitHeading3Small)
                .foregroundColor(.gray800)
            
            ForEach(0..<vm.timeSelect.count, id: \.self) { i in
                HStack {
                    
                    Text(vm.timeSelect[i])
                        .foregroundStyle(.gray600)
                        .font(.suitBody1)
                    Spacer()
                    
                    Text(vm.allTime[i])
                        .foregroundStyle(.gray800)
                        .font(.suitHeading3Small)
                    
                    Button {
                        vm.focusCategoryTapped(idx: i)
                    } label: {
                        Image("chevron")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 8)
                        
                        
                    }
                    .frame(width: 32, height: 32)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
        
        
        
        
        
    }
    
    
    
}


extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
    }
}
