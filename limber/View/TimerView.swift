//
//  MainView.swift
//  limber
//
//  Created by 양승완 on 6/25/25.
//

import SwiftUI


struct TimerView: View {
    @ObservedObject var exampleVM: ExampleVM
    @ObservedObject var timerVM: TimerVM
    @ObservedObject var schedulExVM: ScheduleExVM
    
    @State var showSheet = false
    @State var showModal = false
    @State var topPick = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    topPick = 0
                } label: {
                    Text("지금 시작")
                        .tint(topPick == 0 ? Color.gray800 : Color.limberLightGray)
                        .font(.suitHeading3Small)
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .overlay(
                    Rectangle()
                        .frame(height: topPick == 0 ? 2: 1 )
                        .foregroundColor(topPick == 0 ? Color.limberPurple : Color.gray300), alignment: .bottom
                )
                
                Button {
                    topPick = 1
                } label: {
                    Text("예약 설정")
                        .tint(topPick == 1 ? Color.gray800 : Color.limberLightGray)
                        .font(.suitHeading3Small)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .overlay(
                    Rectangle()
                        .frame(height: topPick == 1 ? 2: 1 )
                        .foregroundColor(topPick == 1 ? Color.limberPurple : Color.gray300), alignment: .bottom)
            }
            VStack(spacing: 0) {
                if topPick == 0 {
                    
                    main
                    
                    Spacer()
                    
                    BottomBtn(title: "시작하기"){
                        self.showModal = true
                        
                    }.padding()
                } else {
                    setting
                }
                
                
            }.background(Color.gray100)
        }
        .fullScreenCover(isPresented: $showModal) {
            BlockAppsSheet(vm: exampleVM, showModal: $showModal)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                .background(Color.black.opacity(0.3))
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                .ignoresSafeArea(.all)
        }
        
        
    }
    
    
    @ViewBuilder
    var main: some View {
        Spacer()
            .frame(height: 60)
        HStack {
            Text("무엇에 집중하고 싶으신가요?")
                .font(.suitHeading3Small)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        ScrollView(.horizontal) {
            
            HStack(spacing: 8) {
                ForEach(timerVM.categorys, id: \.self) { text in
                    Text(text)
                        .foregroundStyle(timerVM.selectedCategory == text ? Color.white : Color.gray500)
                        .frame(width: 68)
                        .frame(maxHeight: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke((timerVM.selectedCategory == text ? Color.LimberPurple : Color.gray300), lineWidth:
                                            timerVM.selectedCategory == text ? 2 : 1.2)
                        )
                        .background(timerVM.selectedCategory == text ? Color.LimberPurple : nil)
                        .cornerRadius(100)
                        .onTapGesture {
                            timerVM.selectedCategory = text
                        }
                }
                
                Label("직접추가", systemImage: "plus")
                    .foregroundStyle(Color.gray500)
                    .frame(width: 112)
                    .frame(maxHeight: .infinity)            .background(Color.gray200)
                    .cornerRadius(100)
                    .onTapGesture {
                        showSheet = true
                    }
                    .sheet(isPresented: $showSheet) {
                        AutoFocusSheet()
                            .presentationDetents([.height(700), ])
                            .presentationCornerRadius(24)
                            .interactiveDismissDisabled(true)
                        
                    }
            }
        }
        .frame(height: 38)
        .padding()
        
        Spacer()
            .frame(height: 48)
        
        HStack {
            Text("얼마나 집중하시겠어요?")
                .font(.suitHeading3Small)
                .padding(.horizontal, 20)
            Spacer()
        }
        
        ZStack {
            Rectangle()
                .frame(width: 320, height: 44)
                .cornerRadius(10)
                .foregroundStyle(
                    Color.gray200.opacity(0.6))
            
            VStack {
                Spacer()
                HStack {
                    CustomTimePickerView(selectedHour: $timerVM.selectingH, selectedMinute: $timerVM.selectingM)
                        .frame(width: 200, height: 200)
                        .offset(x: -10)
                }
                .offset( x: -10, y: -2)
            }
            
        }.frame(maxWidth: .infinity, maxHeight: 200)
    }
    
    @ViewBuilder
    var setting: some View {
        Spacer()
            .frame(height: 25)
        VStack {
            HStack {
                Text("진행 예정인 실험")
                    .font(.suitHeading3Small)
                Spacer()
                Button {
                } label: {
                    
                    HStack(spacing: 4) {
                        Image("pencil")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(.leading, 12)
                        Text("편집하기")
                            .frame(width: 49, height: 20)
                            .font(.suitBody2)
                            .padding(.trailing, 12)
                    }
                }
                .frame(width: 95, height: 36)
                .foregroundStyle(.gray600)
                .background(.gray200)
                .cornerRadius(100)
            }
            
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(timerVM.staticModels, id: \.self) { model in
                            HStack(alignment: .top) {
                                // 체크
                                //                                Button(action: {
                                //                                    if timerVM.checkedModels.contains(model) {
                                //                                        timerVM.checkedModels.remove(model)
                                //                                    } else {
                                //                                        timerVM.checkedModels.insert(model)
                                //                                    }
                                //                                })
                                //
                                
                                //                                {
                                //                                    ZStack {
                                //                                        Circle()
                                //                                            .fill(timerVM.checkedModels.contains(model) ? Color.LimberPurple : Color.white)
                                //                                        if timerVM.checkedModels.contains(model) {
                                //                                            Image(systemName: "checkmark")
                                //                                                .foregroundColor(.white)
                                //                                        }
                                //                                    }
                                //                                    .frame(width: 24, height: 24)
                                //                                    .overlay(
                                //                                        Circle()
                                //                                            .stroke(Color.gray300, lineWidth: 1)
                                //                                    )
                                //                                    .contentShape(Circle())
                                //                                }
                                //                                .padding(8)
                                
//                                Spacer()
//                                    .frame(width: 12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("\(model.category)")
                                        .font(Font.suitBody2)
                                        .frame(width: 49, height: 28)
                                        .background(Color.LimerLightPurple)
                                        .foregroundStyle(Color.LimberPurple)
                                        .cornerRadius(100)
                                        .padding(.bottom, 12)
                                    
                                    Text("\(model.title)")
                                        .padding(.bottom, 6)
                                    Text("\(model.timer)")
                                }
                                Spacer()
                                
                                Toggle("", isOn: Binding(
                                    get: { model.isOn },
                                    set: { newValue in
                                        timerVM.toggleChanged(id: model.id, newValue: newValue)
                                    }
                                ))
                                .labelsHidden()
                                .tint(Color.LimberPurple)

                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
                
                Button {
                    schedulExVM.on700()
                    showSheet = true
                } label: {
                    Image("addBtn")
                }
                .frame(width: 56, height: 56)
                .padding(.bottom, 40)
                
            }
            
        }.padding(.horizontal, 20)
            .sheet(isPresented: $showSheet) {
                ScheduleExSheet(vm: schedulExVM)
                    .presentationDetents(schedulExVM.heights, selection: $schedulExVM.detents)
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(24)
                    .interactiveDismissDisabled()
            }
    }
    
}

#Preview {
    TimerView(exampleVM: ExampleVM(), timerVM: TimerVM(), schedulExVM: ScheduleExVM())
}



