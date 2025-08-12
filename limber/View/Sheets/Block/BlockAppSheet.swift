//
//  BlockedAppSheet.swift
//  limber
//
//  Created by 양승완 on 7/4/25.
//

import SwiftUI
import DeviceActivity
import FamilyControls

struct BlockAppsSheet: View {
  @EnvironmentObject var router: AppRouter
  @Environment(\.dismiss) private var dismiss
  @StateObject var blockVM: BlockVM = BlockVM()
  
  @ObservedObject var deviceReportActivityVM: DeviceActivityReportVM
  
  @State var untilHour: Int
  @State var untilMinute: Int
  @State var focusTypeId: Int
  
  @State private var showPicker = false
  @State private var isEnable = true
  
  @Binding var showModal: Bool

  
  
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        ZStack( alignment: .topTrailing) {
          Image("topLimber")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
          
          HStack {
            Spacer()
            Button(action: {
              blockVM.reset()
              showModal = false
            }) {
              Image("xmark")
            }
          }
          .padding([.top, .trailing], 20)
        }
        Spacer().frame(height: 28)
        
        VStack(spacing: 0) {
          
          HStack(spacing: 0) {
            Text("\(self.untilHour)시간 \(self.untilMinute)분")
              .foregroundColor(Color.limberPurple)
              .font(.suitHeading2)
            Text("동안")
              .foregroundColor(.gray800)
              .font(.suitHeading2)
          }
          HStack(spacing: 0) {
            Text("\(blockVM.pickedApps.count)개")
              .foregroundColor(Color.limberPurple)
              .font(.suitHeading2)
            Text("의 앱이 차단돼요")
              .foregroundColor(.gray800)
              .font(.suitHeading2)
          }
        }
        .multilineTextAlignment(.center)
        .padding(.bottom, 24)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(alignment: .center) {
            ForEach(blockVM.pickedApps, id: \.self) { app in
              if let token = app.token {
                VStack(spacing: 0) {
                  Spacer()
                  Label(token)
                    .labelStyle(iconLabelStyle())
                  Label(token)
                    .labelStyle(textLabelStyle())
                    .scaleEffect(CGSize(width: 0.4, height: 0.4))
                  Spacer()
                }
                .frame(width: 100, height: 76, alignment: .center)
                .background(Color.gray100)
                .cornerRadius(8)

              }
            }
          }
        }
        .frame(height: 76)
        .padding([.bottom, .horizontal], 16)
        
        Button {
          blockVM.reset()
          showPicker = true
        } label: {
          HStack(spacing: 8) {
            Spacer()
            Image( "pencil")
              .resizable()
              .frame(width: 16,height: 16)
              .foregroundColor(.gray500)
            
            Text("편집하기")
              .foregroundColor(.gray500)
              .font(.system(size: 15))
            Spacer()
          }
          .padding(.bottom, 12)
        }
        Spacer()
        
        Text("버튼을 누르면 실험이 시작돼요")
          .foregroundColor(.gray500)
          .font(.system(size: 15))
          .padding(.bottom, 8)
        
        BottomBtn(isEnable: $isEnable, title: "시작하기") {
          if let endDate = TimeManager.shared.addTime(hours: self.untilHour, minutes: self.untilMinute), let startDate = TimeManager.shared.addTime(),
             let schedule = createSchedule(addHours: self.untilHour, addMinutes: self.untilMinute)
          {
            let deviceActivityCenter = DeviceActivityCenter()

            let startTime = TimeManager.shared.formatter.string(from: startDate)
            let endTime = TimeManager.shared.formatter.string(from: endDate)
            let dto = TimerNowDto(focusTypeId: self.focusTypeId, startTime: startTime, endTime:           endTime)
            do {
              TimerSharedManager.shared.saveTimeringSession(dto)
              try deviceActivityCenter.startMonitoring(.init("0") , during: schedule)
            } catch {
              print("err \(error)")
            }
          }
        
          blockVM.setShieldRestrictions()
          
          dismiss()
        }
        .padding(20)
      }
      .frame(height: 515)
      .background(Color.white)
      .cornerRadius(16)
      .padding(.horizontal, 20)
      
    }.background(ClearBackground())
      .sheet(isPresented: $showPicker) {
        BlockBottomSheet(isOnboarding: false, vm: blockVM, onComplete: {})
          .presentationDetents([.height(700),])
          .presentationCornerRadius(24)
          .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 4)
      }
      .onAppear {
        blockVM.setPicked()
      }
  }
  func createSchedule(addHours: Int, addMinutes: Int) -> DeviceActivitySchedule? {
      let now = Date()
      let calendar = Calendar.current

      // 현재 시와 분 구함
      let nowComponents = calendar.dateComponents([.hour, .minute], from: now)
      let nowHour = nowComponents.hour ?? 0
      let nowMinute = nowComponents.minute ?? 0

      // 종료 시간 계산
      var endDate = calendar.date(byAdding: DateComponents(hour: addHours, minute: addMinutes), to: now)!
      let endComponents = calendar.dateComponents([.hour, .minute], from: endDate)

      // DeviceActivitySchedule 은 DateComponents 로 받음
      return DeviceActivitySchedule(
          intervalStart: DateComponents(hour: nowHour, minute: nowMinute),
          intervalEnd: DateComponents(hour: endComponents.hour, minute: endComponents.minute),
          repeats: false
      )
  }
}

struct BlockedApp: Identifiable {
  let id = UUID()
  let name: String
  let image: String
}
struct ClearBackground: UIViewRepresentable {
  
  public func makeUIView(context: Context) -> UIView {
    let view = ClearBackgroundView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }
  public func updateUIView(_ uiView: UIView, context: Context) {
    
    
  }
}

class ClearBackgroundView: UIView {
  open override func layoutSubviews() {
    guard let parentView = superview?.superview else {
      return
    }
    parentView.backgroundColor = .clear
  }
}

