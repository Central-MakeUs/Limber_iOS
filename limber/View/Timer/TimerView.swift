//
//  MainView.swift
//  limber
//
//  Created by 양승완 on 6/25/25.
//

import SwiftUI
import _SwiftData_SwiftUI
import DeviceActivity

struct TimerView: View {
  @Environment(\.modelContext) private var modelContext
  
  @ObservedObject var deviceReportActivityVM: DeviceActivityReportVM
  @ObservedObject var timerVM: TimerVM
  @ObservedObject var schedulExVM: ScheduleExVM
  
  @State var showSheet = false
  @State var showModal = false
  @State var topPick = 1
  
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
            .foregroundColor(topPick == 0 ? .limberPurple : .gray300), alignment: .bottom
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
            if !timerVM.isTimering {
              main
              Spacer()
              BottomBtn(isEnable: $timerVM.btnEnable, title: "시작하기", action:  {
                timerVM.nowStarting(completion: {
                  self.showModal = true

                }                
                )
                
              })
              .padding(20)
              .disabled(!timerVM.btnEnable)
            } else {
              alreadyTimer
            }
        
            
          } else {
            setting
                  .onAppear {
                      timerVM.onAppear()
                  }
          }
          
          
        }
        .background(Color.gray100)


     
    }
    .modifier(ToastModifier(isPresented: $timerVM.toastOn, message: "타이머는 15분 이상부터 시작할 수 있습니다.", duration: 2))
    .fullScreenCover(isPresented: $showModal) {
      BlockAppsSheet(deviceReportActivityVM: deviceReportActivityVM, untilHour: timerVM.selectingH, untilMinute: timerVM.selectingM, focusTypeId: timerVM.categorys.firstIndex(of: timerVM.selectedCategory) ?? 0, showModal: $showModal)
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .background(Color.black.opacity(0.3))
        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        .ignoresSafeArea(.all)
    }
    .fullScreenCover(isPresented: $timerVM.delAlert) {
      AlertSheet(timerVM: timerVM)
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .background(Color.black.opacity(0.3))
        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        .ignoresSafeArea(.all)
    }
    .onAppear {
      timerVM.onAppear()
    }
    
    
  }
  
  @ViewBuilder
  var alreadyTimer: some View {
    Spacer().frame(minHeight: 70)

    VStack(alignment: .center, spacing: 0) {
      Image("alreadyLab")
        .padding(.bottom, 12)
    
      Text("현재 진행 중인 실험이 있어요")
        .font(.suitHeading1)
        .padding(.bottom, 12)

      Text("실험이 종료된 후에")
        .font(.suitBody2)
        .foregroundStyle(.gray600)
      
      Text("새로운 실험을 시작할 수 있어요")
        .font(.suitBody2)
        .foregroundStyle(.gray600)
    }
    .frame(maxWidth: .infinity)
    
    Spacer()
      .frame(minHeight: 152)

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
          
          //TODO: 직접 추가
          //                Label("직접추가", systemImage: "plus")
          //                    .foregroundStyle(Color.gray500)
          //                    .frame(width: 112)
          //                    .frame(maxHeight: .infinity)
          //                    .background(Color.gray200)
          //                    .cornerRadius(100)
          //                    .onTapGesture {
          //                        showSheet = true
          //                    }
          //                    .sheet(isPresented: $showSheet) {
          //                        AutoFocusSheet()
          //                            .presentationDetents([.height(700), ])
          //                            .presentationCornerRadius(24)
          //                            .interactiveDismissDisabled(true)
          //
          //                    }
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
            CustomTimePickerView(selectedHour: $timerVM.selectingH, selectedMinute: $timerVM.selectingM, hourText: "시간")
              .frame(width: 200, height: 200)
              .offset(x: -10)
          }
          .offset( x: -10, y: -2)
        }
        
      }.frame(maxWidth: .infinity, maxHeight: 200)
 
    
  }
  
  
  //MARK: 예약설정, 예약 설정
  @ViewBuilder
  var setting: some View {
    Spacer()
      .frame(height: 25)
    VStack {
      HStack {
        if !timerVM.isEdit {
          Text("진행 예정인 실험")
            .font(.suitHeading3Small)
            Text("\(timerVM.timers.count)")
            .foregroundStyle(.limberPurple)
            .font(.suitHeading3Small)
          Spacer()
          
          editBtn
          
        } else {
          CellAllChecker(timerVM: timerVM, action: {
            allCheckerTapped()
          })
          Text("전체선택")
            .font(.suitHeading3Small)
            .foregroundStyle(.gray800)
          Spacer()
          buttons
        }
        
      }
      
      ZStack(alignment: .bottomTrailing) {
        ScrollView {
          VStack(spacing: 12) {
            ForEach(timerVM.timers, id: \.id) { model in
              HStack(alignment: .top) {
                if timerVM.isEdit {
                  CellChecker(timerVM: timerVM, model: model, action: {
                    if timerVM.checkedModels.contains(model) {
                      timerVM.checkedModels.remove(model)
                    } else {
                      timerVM.checkedModels.insert(model)
                    }
                  })
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(model.getFocusTitle() )")
                    .font(Font.suitBody2)
                    .frame(width: 49, height: 28)
                    .background(
                        model.status == .ON
                      ? Color.LimerLightPurple
                      : Color.gray200)
                    .foregroundStyle(
                        model.status  == .ON
                      ? Color.LimberPurple
                      : Color.gray500)
                    .cornerRadius(100)
                    .padding(.bottom, 12)
                  
                  Text("\(model.title)")
                    .lineLimit(2)
                    .padding(.bottom, 6)
                    .foregroundStyle(model.status == .ON
                                     ? Color.gray800
                                     : Color.gray600)
                  Text("\(model.getDays()) \(model.startTime)-\(model.endTime)")
                    .foregroundStyle(model.status == .ON
                                     ? Color.gray600
                                     : Color.gray400)
                }
                Spacer()
                if !timerVM.isEdit {
                  
                  Toggle("", isOn: Binding(
                    get: { model.status == .ON },
                    set: { newValue in
                      
                      Task {
                        await toggleChanged(id: model.id, newValue: newValue)
                      }
                    }
                  ))
                  .labelsHidden()
                  .tint(Color.LimberPurple)
                }
                
              }
              .frame(maxWidth: .infinity)
              .padding(20)
              
            }
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 0)
            .background(.white)
            .cornerRadius(10)
          }
        }
        
        HStack {
          Spacer()
          Button {
            schedulExVM.on700()
            showSheet = true
          } label: {
            Image("addBtn")
          }
          .frame(width: 56, height: 56)
        }
        .padding(.bottom, 40)
      }
      
    }.padding(.horizontal, 20)
      .sheet(isPresented: $showSheet) {
        ScheduleExSheet(vm: schedulExVM)
          .presentationDetents(schedulExVM.heights, selection: $schedulExVM.detents)
          .presentationDragIndicator(.hidden)
          .presentationCornerRadius(24)
          .interactiveDismissDisabled()
          .ignoresSafeArea(.keyboard)
        
      }
      .onChange(of: showSheet) { _, newValue in
        if newValue == false {
          schedulExVM.onBottomSheet()
          
        }
      }
  }
  
  @ViewBuilder
  var editBtn: some View {
    
    Button {
      timerVM.isEdit = true
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
    
  @ViewBuilder
  var buttons: some View {
    HStack(spacing: 8) {
      Button {
        timerVM.setDeleteSheet()
      } label: {
        HStack {
          Text("삭제")
            .frame(width: 25, height: 20)
            .font(.suitBody2)
        }
      }
      .frame(width: 65, height: 36)
      .foregroundStyle(.white)
      .background(.gray700)
      .cornerRadius(100)
      
      Button {
        timerVM.isEdit = false
      } label: {
        HStack {
          Text("완료")
            .frame(width: 25, height: 20)
            .font(.suitBody2)
        }
      }
      .frame(width: 65, height: 36)
      .foregroundStyle(.gray600)
      .background(.gray200)
      .cornerRadius(100)
      
    }
    
  }
  
  
  //TODO: 백엔드 도입 후 다시 ViewModel 로 이동
  func toggleChanged(id: Int, newValue: Bool) async {
    
    if let index = timerVM.timers.firstIndex(where: { $0.id == id }) {
      do {
        
        let result = try await self.timerVM.timerRepository.updateTimerStatus(id: id, dto: TimerStatusUpdateDto(status: timerVM.timers[index].status))
        
        timerVM.timers[index].status = result.status

        let deviceActivityCenter = DeviceActivityCenter()
        
        if result.status != .ON {
          deviceActivityCenter.stopMonitoring([.init(timerVM.timers[index].id.description)])
        } else {
          let intervalStart = TimeManager.shared.timeStringToDateComponents(timerVM.timers[index].startTime, dateFormatStr: "HH:mm") ?? DateComponents()
          let intervalEnd = TimeManager.shared.timeStringToDateComponents(timerVM.timers[index].endTime, dateFormatStr: "HH:mm") ?? DateComponents()
          try deviceActivityCenter.startMonitoring(.init(timerVM.timers[index].id.description), during: .init(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: true))
        }
      } catch {
        print("Error ::: ToggleChanged \(error)")
      }
  

      
//      timerVM.timers[index].status = newValue ? .running : .canceled
//      do {
//        let deviceActivityCenter = DeviceActivityCenter()
//
//        
//        if !newValue {
//          deviceActivityCenter.stopMonitoring([.init(timerVM.timers[index].id.description)])
//        } else {
//          let intervalStart = TimeManager.shared.timeStringToDateComponents(timerVM.timers[index].startTime, dateFormatStr: "HH:mm") ?? DateComponents()
//          let intervalEnd = TimeManager.shared.timeStringToDateComponents(timerVM.timers[index].endTime, dateFormatStr: "HH:mm") ?? DateComponents()
//          try deviceActivityCenter.startMonitoring(.init(timerVM.timers[index].id.description), during: .init(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: true))
//        }
//    
//      } catch {
//        print("err \(error)")
//      }
    }
  }
  
  
  func allCheckerTapped() {
    timerVM.isAllChecker.toggle()
    if timerVM.isAllChecker {
      _ = timerVM.timers.map {
        timerVM.checkedModels.insert($0)
      }
    } else {
      timerVM.checkedModels.removeAll()
    }
  }
  
}




