//
//  test.swift
//  limber
//
//  Created by 양승완 on 7/12/25.
//

import SwiftUI
import DeviceActivity
import ManagedSettings

struct HomeView: View {
    @ObservedObject var homeVM: HomeVM
    @ObservedObject var deviceActivityReportVM = DeviceActivityReportVM()
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
                .background(Color.limberPurple)
            
            VStack(spacing: 0) {
                HStack {
                    Image("LIMBER")
                        .foregroundStyle(.limerLightPurple)
                    
                    Spacer()
                    Button(action: {}) {
                        HStack(spacing: 2) {
                            Image("appAddIcon")
                            Text("4")
                        }
                        .font(.suitBody2)
                        .foregroundStyle(Color.limerLightPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                    }
                    
                    
                    Button(action: {
            
                        
                    }) {
                        Image("bell")
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 18)
                
                Image("mainCharactor_1")
                    .resizable()
                    .frame(width: 120, height: 120)
                
                Button(action: {
                    if !homeVM.isTimering {
                        router.push(.circularTimer(hour: 12.0))
                    } else {
                        router.selectedTab = .timer
                    }
                    
                }) {
                    if homeVM.isTimering {
                        HStack(spacing: 0) {
                            Image("timer")
                                .frame(width: 36, height: 36)
                                .foregroundStyle(Color.limerLightPurple)
                                .background(Color.primaryMiddleDark)
                                .cornerRadius(100, corners: .allCorners)
                            Spacer()
                                .frame(width: 20)
                            Text(homeVM.timerStr)
                                .foregroundStyle(.white)
                                .font(.suitHeading3Small)
                            Spacer()
                                .frame(width: 8)
                            Image("chevron")
                                .foregroundStyle(Color.white)
                        }
                    } else {
                        Text("실험 시작하기")
                            .font(.suitHeading3Small)
                            .foregroundColor(.white)
                            .padding(.horizontal, 52)
                            .padding(.vertical, 16)
                    }
                  
                                
                    
                    
                }
                .frame(width: 200, height: 56)
                .background(
                    LinearGradient(
                        stops: [
                            
                            Gradient.Stop(color: Color(red: 0.73, green: 0.38, blue: 1), location: 0.45),
                            Gradient.Stop(color: Color(red: 0.51, green: 0.03, blue: 0.82), location: 0.66),
                            Gradient.Stop(color: Color(red: 0.44, green: 0.08, blue: 0.85), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.79, y: 2.34),
                        endPoint: UnitPoint(x: 0.4, y: 0)
                    )
                )
                .clipShape(Capsule())
                
                mainViewTopLabel()
                    .background(Color.lightYellow)
                    .cornerRadius(100)
                    .padding(.horizontal, 33)
                    .padding(.top, 34)
                

                DeviceActivityReport(deviceActivityReportVM.contextTotalActivity, filter: deviceActivityReportVM.filter)
                
                Spacer()
            }
        }
    }
}

struct ActivityRow: View {
    let name: String
    let time: String
    let icon: ApplicationToken?
    
    var body: some View {
        HStack {
            if (icon != nil) {
                Label(icon!)
                    .labelStyle(.iconOnly)
                Spacer()
                    .frame(width: 16)
                
            } else {
                Text(name)
                    .font(.suitCaption1)
                    .foregroundStyle(Color.gray500)
                Spacer()
                    .frame(width: 16)
            }
            
            Text(time)
                .font(.suitBody3)
                .foregroundColor(.gray400)
            Spacer()
        }
        .frame(height: 20)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct mainViewTopLabel: View {
    @State var text1 = "도파민 노출"
    @State var text2 = "이 과다해요! 집중을 더 늘려보아요"
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: 12)
            Image("dopamineIcon")
            Spacer()
                .frame(width: 6)
            
            Text(text1)
                .foregroundStyle(Color(red: 1, green: 0.27, blue: 0.17))
            Text(text2)
            Spacer()
                .frame(width: 20)
        }
        .frame(height: 44)
        .font(.suitBody2)
    }
    
}
