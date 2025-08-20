//
//  FocusExperimentView.swift
//  limber
//
//  Created by 양승완 on 7/15/25.
//


import SwiftUI


struct RetrospectiveView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var router: AppRouter
  @StateObject var vm: RetrospectiveVM
  
  @State var saveAlertSheet = false
  private let beakerImages = ["20Beaker","60Beaker","100Beaker"]
  private let stepImages = ["20Balloon","60Balloon","100Balloon"]

  
  var body: some View {

    
      
      VStack(spacing: 0) {
        ZStack(alignment: .center) {
          Text("\(vm.date) \(vm.labName)실험 회고")
            .font(.suitBody1)
            .foregroundColor(.gray400)
          
          HStack {
            Spacer()
            Button(action: {
              dismiss()
            }) {
              Image("xmark")
            }
            
          }
          .padding(.trailing, 20)
        }

        
        Spacer().frame(height: 50)
        
        Text("이번 실험에 얼마나 몰입했나요?")
          .font(.suitHeading3)
          .foregroundColor(.white)
          .frame(height: 32)
        
        Spacer().frame(height: 40)
        
          ZStack {
            if let animName = vm.transitionAnimationName {
                LottieView(name: animName, onCompleted: {
                  vm.transitionAnimationName = nil
              }, loopMode: .playOnce)
              } else {
                Image(beakerImages[Int(vm.currentIndex)])
                      .resizable()
                      .scaledToFit()
         
              }
          }
          .frame(width: 200, height: 200)
        
        Spacer()
          .frame(height: 62)
        
        VStack(spacing: 8) {
          ZStack(alignment: .trailing) {
            VStack {
              CustomStepSlider(vm: vm, steps: [0,50,100], stepImages: stepImages)
              
            }
        
          }
          .padding(.horizontal, 70)
          .padding(.vertical, 12)
          
          HStack {
            Text("거의 못했어요")
              .frame(width: 100)
            Spacer()
            Text("꽤 집중했어요")
              .frame(width: 100)
            Spacer()
            Text("완전 몰입했어요")
              .frame(width: 100)
            
          }
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.gray400)
          .frame(width: 340)
        }
        .padding(.bottom, 30)
        
        VStack {
          TextField("", text: $vm.focusDetail, prompt: Text("오늘 집중한 활동을 간단히 기록해보세요")
            .font(.suitBody2)
            .foregroundStyle(Color.gray400), axis: .vertical)
          .font(.suitBody2)
          .foregroundStyle(Color.white)
          .lineLimit(3...6)
          .padding(20)
        }
        .background(.white.opacity(0.1))
        .cornerRadius(10)
        .padding(20)
        
        Spacer()
        
        Text("회고를 다 완성해야 저장할 수 있어요")
          .font(.suitBody2)
          .foregroundStyle(.gray500)
        
        BottomBtn(isEnable: $vm.isEnable, title: "저장하기", action: {
          vm.save()
          saveAlertSheet = true
          
        })
        .padding(20)
        
      }
      .background {
      Image("DarkBackground")
        .resizable()
        .ignoresSafeArea()
    }
    .toolbar(.hidden, for: .navigationBar)
    .hideKeyboardOnTap()
    .fullScreenCover(isPresented: $saveAlertSheet, content: {
      SaveAlertSheet(leftAction: {
        router.poptoRoot()
      }, rightAction: {
        router.poptoRoot()
        router.selectedTab = .laboratory

      })
      .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
      .background(Color.black.opacity(0.3))
      .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
      .ignoresSafeArea(.all)
      
    })

    
  }
  
  
}
#Preview {
  RetrospectiveView(vm: RetrospectiveVM(date: "", labName: "", timerId: 0, historyId: 0))
}

