//
//  AlertSheet.swift
//  limber
//
//  Created by 양승완 on 7/10/25.
//

import SwiftUI
import SwiftData
import DeviceActivity

struct AlertSheet: View {
  @ObservedObject var timerVM: TimerVM
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack {
      Spacer()
      VStack {
        Spacer()
          .frame(height: 32)
        Text("정말 삭제할까요?")
          .font(.suitHeading3)
          .foregroundStyle(.gray800)
        Text("삭제한 실험은 복구할 수 없어요.")
          .font(.suitHeading3)
          .foregroundStyle(.gray800)
        Spacer()
        HStack(spacing: 8) {
          Button {
            timerVM.isEdit = false
            timerVM.delAlert = false
            dismiss()
          } label: {
            Text("취소")
              .font(.suitHeading3Small)
              .frame(maxWidth: .infinity , maxHeight: .infinity)
            
          }
          .foregroundStyle(.gray800)
          .background(.gray200)
          .cornerRadius(10)
          
          Button {
            Task {
              await timerVM.deleteTimers(action: {
                timerVM.onAppear()
                dismiss()
              })
            }
       
          } label: {
            Text("삭제하기")
              .font(.suitHeading3Small)
              .frame(maxWidth: .infinity , maxHeight: .infinity)
            
          }
          .background(.limberPurple)
          .cornerRadius(10)
          
        }
        .foregroundStyle(.white)
        .frame(height: 54)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
        
        
      }
      .frame(height: 180)
      .background(.white)
      .cornerRadius(16)
      .padding(.horizontal, 20)
      Spacer()
      
    }
    .background(ClearBackground())
    
    
  }
  
}



struct NotiAlertSheet: View {
  var action: () -> ()
  
  @Binding var isAlert: Bool
 
  
  var body: some View {
    VStack {
      Spacer()
      VStack {
        Spacer()
          .frame(height: 32)
        Text("알림권한을 설정하지 않았어요.")
          .font(.suitHeading3)
          .foregroundStyle(.gray800)
        Text("설정 > 림버에서 알림 권한을 꼭 설정해주세요")
          .font(.suitHeading3)
          .foregroundStyle(.gray800)
        Spacer()
        HStack(spacing: 8) {
        
          Button {
            action()

          } label: {
            Text("확인")
              .font(.suitHeading3Small)
              .frame(maxWidth: .infinity , maxHeight: .infinity)
            
          }
          .frame(maxWidth: .infinity)
          .background(.limberPurple)
          .cornerRadius(10)
          
        }
        .foregroundStyle(.white)
        .frame(height: 54)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
        
        
      }
      .frame(height: 180)
      .background(.white)
      .cornerRadius(16)
      .padding(.horizontal, 20)
      Spacer()
      
    }
    .background(ClearBackground())
    
    
  }
  
}

struct ReAskAlertSheet: View {
  @Environment(\.dismiss) var dismiss
  var leftAction: () -> ()
  var rightAction: () -> ()
  
  @State var topText: String
  @State var bottomText: String
  
  @State var leftBtnText: String
  @State var rightBtnText: String
  
  var body: some View {
    VStack {
      Spacer()
      VStack {
        Spacer()
          .frame(height: 32)
        Text(topText)
          .font(.suitHeading3)
          .foregroundStyle(.gray800)
        Text(bottomText)
          .font(.suitHeading3)
          .foregroundStyle(.gray800)
        Spacer()
        HStack(spacing: 8) {
          Button {

            leftAction()
          } label: {
            Text(leftBtnText)
              .font(.suitHeading3Small)
              .frame(maxWidth: .infinity , maxHeight: .infinity)
            
          }
          .foregroundStyle(.gray800)
          .background(.gray200)
          .cornerRadius(10)
          
          Button {
            rightAction()
       
          } label: {
            Text(rightBtnText)
              .font(.suitHeading3Small)
              .frame(maxWidth: .infinity , maxHeight: .infinity)
            
          }
          .background(.limberPurple)
          .cornerRadius(10)
          
        }
        .foregroundStyle(.white)
        .frame(height: 54)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
        
      }
      .frame(height: 180)
      .background(.white)
      .cornerRadius(16)
      .padding(.horizontal, 20)
      Spacer()
      
    }
    .background(ClearBackground())
    
    
  }
  
}

struct SaveAlertSheet: View {
  @Environment(\.dismiss) var dismiss
  var leftAction: () -> ()
  var rightAction: () -> ()
  
  var topText: String = "회고가 저장되었어요!"
  
  var leftBtnText: String = "홈으로 가기"
  var rightBtnText: String = "리포트 보기"
  
  var body: some View {
    VStack {
      Spacer()
      VStack {
        Spacer()
          .frame(height: 20)
        
        Image("checkmark_x2")
          .frame(width: 40, height: 40)
        
        Text(topText)
          .font(.suitHeading3)
          .foregroundStyle(.gray800)
  
        
        Spacer()
        HStack(spacing: 8) {
          Button {

            leftAction()
            dismiss()
          } label: {
            Text(leftBtnText)
              .font(.suitHeading3Small)
              .frame(maxWidth: .infinity , maxHeight: .infinity)
            
          }
          .foregroundStyle(.gray800)
          .background(.gray200)
          .cornerRadius(10)
          
          Button {
            rightAction()
            dismiss()
       
          } label: {
            Text(rightBtnText)
              .font(.suitHeading3Small)
              .frame(maxWidth: .infinity , maxHeight: .infinity)
            
          }
          .background(.limberPurple)
          .cornerRadius(10)
          
        }
        .foregroundStyle(.white)
        .frame(height: 54)
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
        
      }
      .frame(height: 180)
      .background(.white)
      .cornerRadius(16)
      .padding(.horizontal, 20)
      Spacer()
      
    }
    .background(ClearBackground())
    
    
  }
  
}
