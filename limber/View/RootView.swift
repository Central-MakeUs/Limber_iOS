//
//  RootView.swift
//  limber
//
//  Created by 양승완 on 6/24/25.
//

import SwiftUI

struct RootView: View {

    var contentVM = ContentVM()
    
    @State var selectedTab: Tab = .home
       
       var body: some View {
           VStack(spacing: 0) {
               Spacer()
               switch selectedTab {
               case .home:
                   MainView()
               case .timer:
                   BView()
               case .laboratory:
                   CView()
               case .more:
                   SettingView()
                   
               }
               Spacer()

               CustomTabView(selectedTab: $selectedTab)
           }
           .edgesIgnoringSafeArea(.bottom)

       }
//    var body: some View {
//        ZStack {
//            TabView(selection: $selected) {
////                Group {
//                    NavigationStack {
//                        ContentView()
//                            .environmentObject(contentVM)
//                            .onAppear(){
//                                Task {
//                                    do {
//                                        try await contentVM.center.requestAuthorization(for: .individual)
//                                        print("성공")
//                                    } catch {
//                                        print("Failed request: \(error)")
//                                    }
//                                }
//                            }
//                    }
//                    .tag(Tab.a)
//                    NavigationStack {
//                        BView()
//                    }
//                    .tag(Tab.b)
//                    NavigationStack {
//                        CView()
//                    }
//                    .tag(Tab.c)
////                }
////                .toolbar(.hidden, for: .tabBar)
//            }
//            
//            
//            VStack {
//                Spacer()
//                tabBar
//            }
//        }
//    }
    
//    var tabBar: some View {
//        HStack {
//            Spacer()
//            Button {
//                selected = .a
//            } label: {
//                VStack(alignment: .center) {
//                    Image(systemName: "star")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 22)
////                    if selected == .a {
////                        Text("View A")
////                            .font(.system(size: 11))
////                    }
//                }
//            }
//            .foregroundStyle(selected == .a ? Color.accentColor : Color.primary)
//            Spacer()
//            Button {
//                selected = .b
//            } label: {
//                VStack(alignment: .center) {
//                    Image(systemName: "gauge.with.dots.needle.bottom.0percent")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 22)
////                    if selected == .b {
////                        Text("View B")
////                            .font(.system(size: 11))
////                    }
//                }
//            }
//            .foregroundStyle(selected == .b ? Color.accentColor : Color.primary)
//            Spacer()
//            Button {
//                selected = .c
//            } label: {
//                VStack(alignment: .center) {
//                    Image(systemName: "fuelpump")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 22)
////                    if selected == .c {
////                        Text("View C")
////                            .font(.system(size: 11))
////                    }
//                }
//            }
//            .foregroundStyle(selected == .c ? Color.accentColor : Color.primary)
//            Spacer()
//        }
//        .padding()
//        .frame(height: 72)
////        .background {
////            RoundedRectangle(cornerRadius: 24)
////                .fill(Color.white)
////                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
////        }
//        .background(Color.gray)
//
//    }
}


struct BView: View {
    var body: some View {
        Text("View B")
    }
}

struct CView: View {
    var body: some View {
        Text("View C")
    }
}
#Preview {
    RootView()
}
