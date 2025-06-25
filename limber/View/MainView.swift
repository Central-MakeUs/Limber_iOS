//
//  MainView.swift
//  limber
//
//  Created by 양승완 on 6/25/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
       
        VStack(spacing: 0) {
            HStack {
                Image("LIMBER")
                Spacer()
            }
            .padding(.leading)
            .background(Color.red)
            
            HStack {
                Image("보류")
                    .resizable()
                    .frame(width: 132,height: 132)
            }.background(Color.black)
                        
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
                .frame(height: 54)
            
            
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
                    Text("오후 8시")
                    .font(
                        Font.system(size: 10)
                    .weight(.medium))
                    .frame(maxWidth: .infinity)
                        
                    Text("오후 8시")
                        .font(
                        Font.system(size: 10)
                            .weight(.medium))
                        .frame(maxWidth: .infinity)

                    Text("오후 8시")
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
                
          
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray)
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
                .frame(height: 12)
            
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
                       Text("오후 8시")
                           .font(
                               Font.system(size: 10)
                                   .weight(.medium))
                           .frame(maxWidth: .infinity)
                       
                       Text("오후 8시")
                           .font(
                               Font.system(size: 10)
                                   .weight(.medium))
                           .frame(maxWidth: .infinity)
                       
                       Text("오후 8시")
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
                   
               }
               .frame(maxWidth: .infinity, alignment: .leading)
               .background(Color.gray)
               .cornerRadius(12)
               .padding(.horizontal)
            
            Spacer()
          
            
            
        }
    }
}

#Preview {
    RootView()
}
