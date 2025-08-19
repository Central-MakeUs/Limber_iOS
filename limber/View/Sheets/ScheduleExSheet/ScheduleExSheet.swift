  //
  //  ScheduleExSheet.swift
  //  limber
  //
  //  Created by 양승완 on 7/4/25.
  //

  import Foundation
  import SwiftUI
  import SwiftData
  let weekdayTextToNumber: [String: String] = [
      "일": "0",
      "월": "1",
      "화": "2",
      "수": "3",
      "목": "4",
      "금": "5",
      "토": "6"
  ]
  struct ScheduleExSheet: View {
 
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @ObservedObject var timerVM: TimerVM
    @ObservedObject var vm: ScheduleExVM
    
    @State var showSheet = false
    @FocusState private var isFocused: Bool
    
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

              ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                  TextField("예약할 실험 타이머의 제목을 설정해주세요", text: $vm.textFieldName)
                    .focused($isFocused)
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
              }
                Spacer()
                
                BottomBtn(isEnable: $vm.scheduleExBtnEnable, title: "예약하기", action: {
                  Task {
                    if await vm.tapReservingBtn(completion: { errCode in
                      if errCode == 409 {
                        DispatchQueue.main.async {
                          vm.dontReserveToastOn = true
                        }
                      } else if errCode == 410 {
                        DispatchQueue.main.async {
                          vm.cantTommorowToast = true
                        }
                      } else if !vm.toastOn {
                        DispatchQueue.main.async {
                          vm.toastOn = true
                        }
                      }
                    }) {
                      timerVM.onAppear()
                      dismiss()
                    }
                    
                  }
                
                  
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
      .modifier(ToastModifier(isPresented: $vm.toastOn, message: "실험 시간은 15분 이상부터 설정할 수 있습니다.", duration: 2))
      .modifier(ToastModifier(isPresented: $vm.dontReserveToastOn, message: "해당 시간 동안에 이미 실험이 있어요!", duration: 2))
      .modifier(ToastModifier(isPresented: $vm.cantTommorowToast, message: "시간 범위는 오늘 내에 시작 시간이 더 작게만 가능해요!", duration: 2))

      
      
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
              Button {
                vm.selectedCategory = text
                isFocused = false
                
              } label: {
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
          
          Button {
            vm.focusCategoryTapped(idx: i)
          } label: {
            HStack {
              Text(vm.timeSelect[i])
                .foregroundStyle(.gray600)
                .font(.suitBody1)
              Spacer()
              
              Text(vm.allTime[i])
                .foregroundStyle(.gray800)
                .font(.suitHeading3Small)
              
              Image("chevron")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 8)
                .frame(width: 32, height: 32)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
          }
        }
      }
      .padding(.horizontal)
      
    }
  }


  #Preview {
    ScheduleExSheet(timerVM: TimerVM(), vm: ScheduleExVM())
  }
