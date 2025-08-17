//
//  ReportView.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//

import SwiftUI
struct ReportView: View {

  @ObservedObject var labVM: LabVM
    var body: some View {
        ScrollView {
          if true {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 12)
                    Text("총 실험 시간")
                        .font(.suitBody2)
                        .foregroundColor(.gray600)
                    Text(labVM.totalScheduledTimes)
                        .font(.suitHeading1)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Text(labVM.weeklyDate)
                            .font(.suitBody2)
                            .foregroundColor(.gray500)
                        
                        Spacer()
                      
                      Button {
                        labVM.leftChevronTap()
                      } label : {
                        Image("leftChevron")
                      }
                      .frame(width: 24, height: 24)
                                          
                      Button {
                        labVM.rightChevronTap()
                      } label : {
                        Image(labVM.weekCount == 0 ? "rightChevron" : "rightChevron_Black")
                          .tint(Color.black)
                      }
                      .frame(width: 24, height: 24)
                    }
                }
       
                WeeklyDataView(labVM: labVM)
                
                HStack {
                    Spacer()
                  SimpleToggle(leftText: "집중 시간", rightText: "몰입도 ", isImmersion: $labVM.isImmersion)
                    Spacer()
                }
                .padding(.bottom, 12)
                
                HStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Image("charts")
                                .frame(width: 36, height: 36)
                                .background(.white)
                                .cornerRadius(18, corners: .allCorners)
                            Text("평균 집중 시간")
                                .font(.suitBody2)
                                .foregroundColor(.primaryVivid)
                            
                          Text(labVM.averageAttentionTime)
                                .foregroundColor(.primaryDark)
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 132)
                    .background(.primayBGNormal)
                    .cornerRadius(10)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Image("fire")
                                .frame(width: 36, height: 36)
                                .background(.white)
                                .cornerRadius(18, corners: .allCorners)
                            
                            Text("평균 집중 몰입도")
                                .font(.suitBody2)
                                .foregroundColor(.primaryVivid)
                            
                          Text(labVM.averageAttentionImmersion)
                                .foregroundColor(.primaryDark)
                            
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 132)
                    .background(.primayBGNormal)
                    .cornerRadius(10)
                    
                }
            }
            .padding(20)
            Rectangle()
                .fill(Color.gray100)
                .frame(maxWidth: .infinity)
                .frame(height: 6)
            
            VStack(alignment: .leading, spacing: 20) {
              
              if !labVM.studyData.isEmpty {
                StudyInsightView(labVM: labVM)
                
                Spacer().frame(height: 12)
              }
               
              
              if !labVM.reasonData.isEmpty {
                StopReasonView(labVM: labVM)
              }
            }
            .padding(.horizontal, 20)
            Spacer()
            

          } else {
            RetrospectEmptyView()
            
          }
        
                       
            
        }
   
    }
}
struct SimpleToggle: View {
    let leftText: String
    let rightText: String
    @Binding var isImmersion: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                  isImmersion = false
                }
            }) {
                Text(leftText)
                    .font(.suitBody2)
                    .foregroundColor(isImmersion ? .gray500 : .black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isImmersion ? Color.clear : Color.white)
                    )
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                  isImmersion = true
                }
            }) {
                Text(rightText)
                    .font(.suitBody2)
                    .foregroundColor(isImmersion ? .black : .gray500)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isImmersion ? Color.white : Color.clear)
                    )
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(Color(UIColor.gray200))
        )
        .frame(maxWidth: 196, maxHeight: 40)
    }
}
