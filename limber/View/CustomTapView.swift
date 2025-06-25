//
//  CustomTapView.swift
//  limber
//
//  Created by 양승완 on 6/24/25.
//

import SwiftUI

enum Tab {
    case home
    case timer
    case laboratory
    case more
}

struct CustomTabView: View {
    
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(alignment: .center) {
    
            Button {
                selectedTab = .home
            } label: {
                VStack(spacing: 8) {
                    Image(selectedTab == .home ? "calendarSelected" : "calendarUnSelected")
                    
                    Text("홈")
//                        .foregroundColor(selectedTab == .calendar ? .Custom.PositiveYellow : .Custom.Black60)
//                        .font(CustomFont.PretendardSemiBold(size: 14).font)
                }
                .offset(x: -5)
            }
            .padding(.horizontal, UIScreen.main.bounds.width / 8 - 30)
            
            Button {
                selectedTab = .timer
            } label: {
                VStack(spacing: 8) {
                    Image(selectedTab == .timer ? "calendarSelected" : "calendarUnSelected")
                    
                    Text("타이머")
//                        .foregroundColor(selectedTab == .calendar ? .Custom.PositiveYellow : .Custom.Black60)
//                        .font(CustomFont.PretendardSemiBold(size: 14).font)
                }
                .offset(x: -5)
            }
            .padding(.horizontal, UIScreen.main.bounds.width/8 - 30)
            
            Button {
                selectedTab = .laboratory
            } label: {
                VStack(spacing: 8) {
                    Image(selectedTab == .laboratory ? "calendarSelected" : "calendarUnSelected")
                    
                    Text("실험실")
//                        .foregroundColor(selectedTab == .calendar ? .Custom.PositiveYellow : .Custom.Black60)
//                        .font(CustomFont.PretendardSemiBold(size: 14).font)
                }
                .offset(x: -5)
            }
            .padding(.horizontal, UIScreen.main.bounds.width/8 - 30)
            
           
            
            Button {
                selectedTab = .more
            } label: {
                VStack(spacing: 8) {
                    Image(selectedTab == .more ? "feedSelected" : "feedUnSelected")
                    
                    Text("더보기")
//                        .foregroundColor(selectedTab == .feed ? .Custom.PositiveYellow : .Custom.Black60)
//                        .font(CustomFont.PretendardSemiBold(size: 14).font)
                }
                .offset(x: 5)
            }
            .padding(.horizontal, UIScreen.main.bounds.width/8 - 30)
        }
        .frame(width: UIScreen.main.bounds.width, height: 85)
        .background(Color.gray)
    }
}
