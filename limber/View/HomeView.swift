//
//  HomeView.swift
//  limber
//
//  Created by 양승완 on 7/12/25.
//
import SwiftUI
import DeviceActivity
import ManagedSettings
import SwiftData

struct HomeView: View {
  @Environment(\.modelContext) private var context
  @ObservedObject var homeVM: HomeVM
  @ObservedObject var deviceActivityReportVM = DeviceActivityReportVM()
  @EnvironmentObject var router: AppRouter
  @EnvironmentObject var blockVM: BlockVM
  @State var showPicker = false

  @StateObject var timerObserver = TimerObserver.shared

  var body: some View {
    GeometryReader { geo in
      let isSmallScreen = geo.size.width < 380

      ZStack {
        Image("mainBackground")
          .resizable()
          .ignoresSafeArea()
          .background(Color.limberPurple)
        VStack(spacing: 0) {
          HStack {
            Image("LIMBER")
              .foregroundStyle(.limerLightPurple)
            Spacer()
            Button(action: {
              showPicker = true
            }) {
              HStack(spacing: 2) {
                Image("appAddIcon")
                Text(homeVM.pickedApps.count.description)
              }
              .font(.suitBody2)
              .foregroundStyle(Color.limerLightPurple)
              .padding(.horizontal, 12)
              .padding(.vertical, 6)
              .background(Color.white.opacity(0.1))
              .clipShape(Capsule())
            }
            //          Button(action: {
            //
            //
            //          }) {
            //            Image("bell")
            //              .foregroundColor(.white)
            //              .padding(.leading, 10)
            //          }
          }
          .padding(.horizontal, 24)
          
          
          Image("Limber_Level1")
            .resizable()
            .frame(maxWidth: isSmallScreen ? 140 : 168, maxHeight: isSmallScreen ? 140 : 168)
          
          Spacer()
            .frame(maxHeight: isSmallScreen ? 8 : 12)
          
          
          //TODO: 버튼이랑 시계 icon leading
          Button(action: {
            if homeVM.isTimering {
              router.push(.circularTimer)
            } else {
              router.selectedTab = .timer
            }
          }) {
            if homeVM.isTimering {
              HStack(spacing: 0) {
                Spacer()
                  .frame(width: 12)
                Image("timer")
                  .frame(width: 36, height: 36)
                  .foregroundStyle(Color.limerLightPurple)
                  .background(Color.primaryMiddleDark)
                  .cornerRadius(100, corners: .allCorners)
                Spacer()
                  .frame(maxWidth: 16)
                Text(TimeManager.shared
                  .timeString(from: self.timerObserver.totalTime - self.timerObserver.elapsed))
                .frame(maxWidth: 78)
                .foregroundStyle(.white)
                .font(.suitHeading3Small)
                Spacer()
                  .frame(width: 8)
                Image("chevron")
                  .foregroundStyle(Color.white)
                
              Spacer()
              }
            } else {
              Text("집중 시작하기")
                .lineLimit(1)
                .kerning(-0.2)
                .font(.suitHeading3Small)
                .foregroundColor(.white)
                .padding(.horizontal,isSmallScreen ? 0 : 50)
            }
          }.buttonStyle(.plain)
          .frame(maxWidth: isSmallScreen ? 140: 200, maxHeight: isSmallScreen ? 44: 56)
          .background(
            LinearGradient(
              stops: [
                Gradient.Stop(color: Color(red: 0.73, green: 0.38, blue: 1), location: 0.45),
                Gradient.Stop(color: Color(red: 0.51, green: 0.03, blue: 0.82), location: 0.66),
                Gradient.Stop(color: Color(red: 0.44, green: 0.08, blue: 0.85), location: 1.00),
              ],
              startPoint: UnitPoint(x: 0.79, y: 2.34),
              endPoint: UnitPoint(x: 0.4, y: 0)
            )
          )
          .clipShape(Capsule())
          
          Spacer().frame(maxHeight: isSmallScreen ? 10: 40)
          
          DeviceActivityReport(deviceActivityReportVM.contextTotalActivity, filter: deviceActivityReportVM.filter)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
          
          Spacer()
          
        }
      }
    }
    .onAppear {
      var startTimeStr = ""
      var endTimeStr = ""
      
      if let session = TimerSharedManager.shared.getTimeringSession() {
        startTimeStr = session.startTime.appendingSecondsIfNeeded()
        endTimeStr = session.endTime.appendingSecondsIfNeeded()
      } 
      
      if let startDate = TimeManager.shared.parseTimeString(startTimeStr) , var endDate = TimeManager.shared.parseTimeString(endTimeStr) {
        
        if endDate < startDate {
          endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        }
        homeVM.endDate = endDate
        timerObserver.startDate = startDate
        timerObserver.endDate = endDate
        timerObserver.startTimer()
      }
      
      homeVM.onAppear()
      
    }
    .sheet(isPresented: $showPicker) {
      BlockBottomSheet(isOnboarding: true, vm: blockVM, onComplete: {})
    }
    .presentationDetents([.height(700)])
    .presentationCornerRadius(24)
  }
}


#Preview {
  HomeView(homeVM: HomeVM())
}
