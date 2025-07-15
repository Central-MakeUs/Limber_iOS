//
//  MainView.swift
//  limber
//
//  Created by 양승완 on 6/25/25.
//

import SwiftUI

struct HomeView2: View {
    var body: some View {

            VStack(spacing: 0) {

                HStack {
                    Image("LIMBER")
                    Spacer()
                }
                .padding(.leading)
                HStack {
                    Image("보류")
                        .resizable()
                        .frame(width: 132,height: 132)
                }
                HStack {
                    Text("4개의 앱 관리 중")
                    Image( systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10 ,height: 10)
                }
                Spacer()
                    .frame(height: 20)
                        Button {
                            //
                        } label: {
                            Text("실험 시작하기")
                                .tint(Color.white)
                        }
                        .frame(width: 134, height: 46)
                        .background(Color(red: 0.28, green: 0.33, blue: 0.4))
                        .cornerRadius(8)
                
                Spacer()
                    .frame(height: 60)
                
                HStack {
                    Text("6월 20일 금요일").padding()
                    Spacer()
                }
                
                VStack(alignment: .leading) {
            
                    Text("집중한 시각")
                        .padding(.leading)
                        .padding(.top)
                    Text("집중 시작 전...")
                        .font(Font.system(size: 28, weight: .bold))
                        .padding(.leading)
                    Spacer()
                        .frame(height: 22)
                    HStack {
                        Spacer()
                        Text("오전 8시")
                            .font(
                                Font.system(size: 10)
                                    .weight(.medium))
                            .frame(maxWidth: .infinity)
                        
                        Text("오후 12시")
                            .font(
                                Font.system(size: 10)
                                    .weight(.medium))
                            .frame(maxWidth: .infinity)
                        
                        Text("오후 4시")
                            .font(
                                Font
                                    .system(size: 10)
                                    .weight(.medium)
                            ).frame(maxWidth: .infinity)
                        
                        Text("오후 8시")
                            .font(
                                Font
                                    .system(size: 10)
                                    .weight(.medium)
                            )
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack(alignment: .center) {
                       
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.89, green: 0.91, blue: 0.93))
                    .padding(.horizontal)
                    .cornerRadius(2)
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: 16)

                VStack(alignment: .leading) {
                    Text("도파민 노출 시간")
                        .padding(.leading)
                        .padding(.top)
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("0분")
                            .font(Font.system(size: 28, weight: .bold))
                            .padding(.leading)
                        Text("오늘은 아직 앱 사용 기록이 없어요")
                            .offset(y: -3)
                    }
                    
                    Spacer().frame(height: 40)
                    HStack(spacing: 4) {
                        ForEach( 0...15,
                                    id: \.self
                        ) { _ in
                            VStack {
                                Rectangle()
                                    .frame(width: 17 , height: 20)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 20)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
             
       
                
                Spacer()
              
                
                
            }
            .background(Color.TabBarGray)
    }


}
