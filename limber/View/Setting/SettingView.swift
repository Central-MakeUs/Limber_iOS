//
//  ContentView.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//


import SwiftUI
class SettingVM: ObservableObject {
  @Published var level: String = "LV.1"
  @Published var charactorName: String = "집중 탐험가"
  
}
struct SettingView: View {
  
  @ObservedObject var vm: SettingVM
  @EnvironmentObject var router: AppRouter
  @EnvironmentObject var blockVM: BlockVM

  @State var showPicker: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        Spacer()
          .frame(height: 30)
        
        Image("mainCharactor_1")
          .resizable()
          .frame(width: 140, height: 140)
        
        HStack(spacing: 0) {
          Spacer()
          
          Text("\(vm.level)")
            .font(.suitHeading3Small)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
              RoundedRectangle(cornerRadius: 100)
                .fill(.limberPurple)
            )
            .padding(.trailing, 8)
          
          Text("\(vm.charactorName)")
            .font(.suitHeading2)
            .foregroundColor(.primary)
            .frame(height: 30)
          
            //TODO: 버튼일때 (추후)
//          Image("chevron")
//            .resizable()
//            .frame(width: 24, height: 24)
//            .foregroundStyle(Color.gray400)
          
          Spacer()
        }
        .padding(.horizontal, 20)
        
        Spacer()
          .frame(height: 44)
        
        // 기능 아이콘들
        HStack(spacing: 8) {
          FeatureButton(
            icon: "settingNote",
            title: "집중할 목표",
            action: {
              router.push(.focusTypes)
            }
          )
          .frame(width: 106)
          .background(Color.white)
          .cornerRadius(8)


          FeatureButton(
            icon: "settingApps",
            title: "관리 중인 앱", action: {
              showPicker = true
            }
          )
          .frame(width: 106)
          .background(Color.white)
          .cornerRadius(8)
//
//          FeatureButton(
//            icon: "settingAI_Coaching",
//            title: "AI 집중 코칭",
//            action: {
//              
//            }
//          )
//          .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
   
      }
      .background(Color.primayBGNormal)
      
      
      Spacer()
        .frame(height: 10)
      // 메뉴 리스트
      VStack(spacing: 0) {
        MenuRow(title: "림버의 스토리", hasChevron: true)
//        MenuRow(title: "FAQ", hasChevron: true)
        MenuRow(title: "이용 약관", hasChevron: true)
        MenuRow(title: "개인 정보 처리 방침", hasChevron: true)
//        MenuRow(title: "로그아웃", hasChevron: false, isDestructive: true)
//        MenuRow(title: "회원 탈퇴", hasChevron: false, isDestructive: true)
      }
      .padding(.horizontal, 20)

      Spacer()
    }
    .sheet(isPresented: $showPicker) {
      BlockBottomSheet(isOnboarding: true, vm: blockVM, onComplete: {})
    }
    .presentationDetents([.height(700),])
    .presentationCornerRadius(24)
  }
}





#Preview {
  SettingView(vm: SettingVM())
}
