//
//  LookBackView.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//
import SwiftUI
struct LookBackView: View {
  
  @ObservedObject var labVM: LabVM
  @EnvironmentObject var router: AppRouter
  
  var body: some View {
    VStack {
      HStack {
        LookBackToggle(event: {
          labVM.fetchHistories()
        }, isAll:  $labVM.isAll)
        Spacer()
        HStack {
          Button(action: {
            labVM.isChecked.toggle()
            labVM.fetchHistories()
          }) {
            Image(labVM.isChecked ? "checkmark" : "checkmark_none")
          }
          .buttonStyle(PlainButtonStyle())
          
          Text("미완료만 보기")
            .font(.suitBody2)
            .foregroundStyle(Color.gray600)
        }
   
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 20)
      
      ScrollView {
        if !labVM.histories.isEmpty {
          VStack(spacing: 12) {
            ForEach(labVM.histories) { history in
              HStack {
                VStack(alignment: .leading, spacing: 8) {
                  Text(history.retrospectSummary)
                    .font(.suitBody2)
                    .foregroundColor(.gray500)
                  
                  HStack(spacing: 0) {
                    Text(history.focusTypeTitle)
                      .foregroundColor(.limberPurple)
                    Text("에 집중한 실험")
                      .foregroundColor(.black)
                  }
                  .font(.suitHeading3Small)
                  
                  Spacer()
                    .frame(maxHeight: 10)
                  
                  if history.hasRetrospect {
                    Text(history.retrospectComment ?? "")
                      .font(.suitBody2)
                      .foregroundColor(.gray700)
                  }
                }
                .padding(20)
                
                Spacer()
                
                if history.hasRetrospect {
                  
                  VStack {
                    ZStack(alignment: .center) {
                      Circle()
                        .frame(width: 56, height: 56)
                        .foregroundStyle(Color.primaryVivid)
                      
                      Image(StaticValManager.titleDic[history.focusTypeId] ?? "")
                        .resizable()
                        .frame(width: 40, height: 40)
                      
                      
                      //                    ZStack {
                      //                      Image("ribbon")
                      //                        .resizable()
                      //                        .frame(width: 100, height: 80)
                      //
                      //                    }
                      
                      Text("\(history.retrospectImmersion ?? 0)% 집중")
                        .frame(width: 66, height: 25, alignment: .center)
                        .font(.suitBody3)
                        .foregroundStyle(Color.white)
                        .background(Color.LimberPurple)
                        .cornerRadius(2)
                        .offset(y: 34)
                    }
                    .offset(y: -10)
                    .frame(maxHeight: 80)
                    .padding()
                  }
                  
                } else {
                  VStack {
                    Spacer()
                    Button {
                      let mmddStr = TimeManager.shared.isoToMMdd(history.historyDt)
                      
                      router.push(.retrospective(id: history.timerId, historyId: history.id, date: mmddStr ?? "", focusType: history.focusTypeTitle) )
                      
                    } label: {
                      Text("회고하기")
                        .font(.suitBody1)
                        .foregroundStyle(Color.primaryVivid)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                      
                    }
                    .frame(minWidth: 88, minHeight: 42)
                    .background(Color.primayBGNormal)
                    .cornerRadius(100)
                    .padding([.trailing, .bottom], 20)
                  }
                  
                }
              }
              .frame(maxWidth: .infinity, maxHeight: 116)
              .background(Color.white)
              .cornerRadius(10)
              .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
            }
          }
          .padding()
          
        } else {
          RetrospectEmptyView()
        }
      }
      
    }
    .background(!labVM.histories.isEmpty ? .gray50 : .white)
    .onAppear {
      labVM.fetchHistories()
    }
    
  }
}

#Preview {
  LookBackView(labVM: LabVM())
}
struct LookBackToggle: View {
  let leftText: String = "전체"
  let rightText: String = "주간"
  
  let event: () -> ()
  @Binding var isAll: Bool
  
  var body: some View {
    HStack(spacing: 8) {
      Button(action: {
        withAnimation(.easeInOut(duration: 0.4)) {
          isAll = true
          event()
        }
      }) {
        Text(leftText)
          .font(.suitBody2)
          .foregroundColor(!isAll ? .gray500 : .white)
          .frame(maxWidth: 58)
          .frame(height: 32)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(!isAll ? Color.gray200 : Color.black)
          )
      }
      
      Button(action: {
        withAnimation(.easeInOut(duration: 0.4)) {
          isAll = false
          event()
        }
      }) {
        Text(rightText)
          .font(.suitBody2)
          .foregroundColor(isAll ? .gray500 : .white)
          .frame(maxWidth: 58)
          .frame(height: 32)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(isAll ? Color.gray200 : Color.black)
          )
      }
    }
  }
}
