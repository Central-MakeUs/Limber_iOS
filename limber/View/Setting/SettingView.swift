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
        
        Image("Limber_Level1")
          .resizable()
          .frame(width: 160, height: 160)
        
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
          
          Button {
            router.push(.limberLevelView)
          } label: {
            Text("\(vm.charactorName)")
              .font(.suitHeading2)
              .foregroundColor(.primary)
              .frame(height: 30)
            
            Image("chevron")
              .resizable()
              .frame(width: 24, height: 24)
              .foregroundStyle(Color.gray400)
            
          }
     
          Spacer()
        }
        .padding(.horizontal, 20)
        
        Spacer()
          .frame(height: 44)
        
        // 기능 아이콘들
        HStack(spacing: 8) {
          FeatureButton(
            icon: "settingNote",
            title: "집중 상황",
            action: {
              router.push(.focusTypes)
            }
          )
          .frame(width: 106)
          .background(Color.white)
          .cornerRadius(8)


          FeatureButton(
            icon: "settingApps",
            title: "방해하는 앱", action: {
              showPicker = true
            }
          )
          .frame(width: 106)
          .background(Color.white)
          .cornerRadius(8)

//          FeatureButton(
//            icon: "settingAI_Coaching",
//            title: "AI 집중 코칭",
//            action: {
//              
//            }
//          )
//          .frame(width: 106)
//          .background(Color.white)
//          .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
   
      }
      .background(Color.primayBGNormal)
      
      
      Spacer()
        .frame(height: 10)
      // 메뉴 리스트
      VStack(spacing: 0) {
//        MenuRow(title: "림버의 스토리", hasChevron: true)
        MenuRow(title: "FAQ", hasChevron: true, onTap: {
          if let url = URL(string: "https://www.notion.so/248907c3c029806d93c7e1aacc5aafaa") {
            UIApplication.shared.open(url)
          }
          
        })
//        MenuRow(title: "이용 약관", hasChevron: true)
        MenuRow(title: "개인 정보 처리 방침", hasChevron: true, onTap: {
          if let url = URL(string: "https://www.notion.so/243907c3c0298031aa27f916366a2d5b?source=copy_link") {
            UIApplication.shared.open(url)
          }
        })
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

struct LimberLevelView: View {
  
  @Environment(\.dismiss) var dismiss
  
    struct Level: Identifiable {
        let id = UUID()
        let image: String
        let level: Int
        let title: String
      let isNow: Bool
    }
    
    // 더미 데이터 (에셋 이름은 실제로 Assets에 넣어야 함)
    let levels: [Level] = [
      Level(image: "Limber_Level1", level: 1, title: "집중 입문가", isNow: true),
        Level(image: "Limber_Level2", level: 2, title: "집중 탐험가", isNow: false),
        Level(image: "Limber_Level3", level: 3, title: "집중 조율사", isNow: false),
        Level(image: "Limber_Level4", level: 4, title: "시간 관리자", isNow: false),
        Level(image: "Limber_Level5", level: 5, title: "디지털 평온가", isNow: false),
        Level(image: "Limber_Level6", level: 6, title: "집중 수호가", isNow: false)
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
          Image("background")
            .resizable()
            .ignoresSafeArea()
            VStack(spacing: 24) {
              ZStack(alignment: .center) {
                HStack {
                  Button {
                    dismiss()
                  } label: {
                    
                    Image("backBtn")
                  }.padding(.leading)
                  
                  Spacer()
                  
                }
                Text("림버 레벨")
                  .font(.suitHeading3Small)
                  .foregroundStyle(.white)
                
              }
                Text("집중 시간을 꾸준히 늘려가면 림버가 성장해요!")
                .font(.suitBody2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(levels) { level in
                          VStack {
                            VStack {
                                Image(level.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 140, height: 140)
                      
                            }
                            .frame(maxWidth: 162, maxHeight: 162)
                            .background(level.isNow ? Color.primaryMiddleDark : Color.white.opacity(0.1))
                            .cornerRadius(16)
                          
                          HStack(spacing: 8) {
                            Text("\(level.level)")
                              .font(.suitBody2)
                                .foregroundColor(.LimerLightPurple)
                            Text("\(level.title)")
                              .font(.suitHeading3Small)
                                .foregroundColor(.white)
                          }
                          }
                      
             
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
              Spacer()

              
            }
        }
        .toolbar(.hidden, for: .navigationBar)

    }
}
