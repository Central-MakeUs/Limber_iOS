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
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
                of: .day,
                for: .now
            ) ?? DateInterval()
        )
    )
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Image("LIMBER")
                        .foregroundStyle(.gray400)
                    
                    Spacer()
                    Button(action: {}) {
                        Text("4개의 앱 관리 중")
                            .font(.suitBody2)
                            .foregroundStyle(.white)
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
                .padding(.top, 24)
                .padding(.bottom, 18)
                
                ZStack {
                    Image("보류")
                        .resizable()
                        .frame(width: 136, height: 136)
                    
                        .frame(width: 120, height: 120)
                }
                
                Button(action: {
                    
                    
                }) {
                    Text("실험 시작하기")
                        .font(.suitHeading3Small)
                        .foregroundColor(.white)
                        .padding(.horizontal, 52)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 1, green: 0.45, blue: 0.37), location: 0.05),
                                    Gradient.Stop(color: Color(red: 0.73, green: 0.38, blue: 1), location: 0.4),
                                    Gradient.Stop(color: Color(red: 0.51, green: 0.03, blue: 0.82), location: 0.9),
                                    Gradient.Stop(color: Color(red: 0.44, green: 0.08, blue: 0.85), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.79, y: 2.34),
                                endPoint: UnitPoint(x: 0.3, y: 0)
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(radius: 8, y: 4)
                }
                .frame(width: 200, height: 60)
                .padding(.top, 20)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("오늘의 활동")
                            .font(.suitBody3)
                        HStack(spacing: 0) {
                            Text("집중 시간")
                                .foregroundStyle(Color.limberPurple)
                            Text("이앞서고 있어요! 계속 이어가요")
                        }
                        .font(.suitBody2)
                        
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.88, green: 0.72, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.98, green: 0.96, blue: 1), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: -0.8, y: -4.33),
                        endPoint: UnitPoint(x: 1, y: 0.5)
                    )
                )
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("집중한 시간")
                                .font(.suitBody2)
                                .foregroundColor(.limberPurple)
                            
                            Text("6시간 23분")
                                .font(.suitHeading2)
                                .frame( height: 30 )
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("도파민 노출 시간")
                                .font(.suitBody2)
                                .foregroundColor(.limberOrange)
                            
                            ExampleTextLabel()
                                .frame(height: 30 )
                        }
                    }
                    .padding()
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.limberPurple)
                                .frame(width: geometry.size.width * 0.67, height: 24)
                                .padding(.trailing, 1)
                            
                            Rectangle()
                                .fill(Color.limberOrange)
                                .frame(width: geometry.size.width * 0.33, height: 24)
                                .padding(.leading, 1)
                        }
                        .cornerRadius(12)
                    }
                    .frame(height: 24)
                    .padding(.horizontal)
                    
                    HStack(alignment: .top, spacing: 12) {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Circle().fill(Color.LimberPurple).frame(width: 8, height: 8)
                                Text("집중 활동")
                                    .font(.suitBody2)
                                    .foregroundStyle(Color.gray600)
                                Spacer()
                                
                            }
                            .padding([.vertical, .leading])
                            
                            VStack {
                                
                                VStack(alignment: .leading) {
                                    ActivityRow(name: "학습", time: "1시간 2분", icon: nil)
                                    ActivityRow(name: "학습", time: "56분", icon: nil)
                                    ActivityRow(name: "학습", time: "23분", icon: nil)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                        }
                        .background(Color.gray200)
                        .cornerRadius(10)
                        .padding(.leading)

                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Circle().fill(Color.LimberOrange).frame(width: 8, height: 8)
                                Text("도파민 활동")
                                    .font(.suitBody2)
                                    .foregroundStyle(Color.gray600)
                                Spacer()
                                
                            }
                            .padding([.vertical, .leading])
                            
                            ExampleView()
                                .padding(.horizontal)
                     
                            
                        }
                        .background(Color.gray200)
                        .cornerRadius(10)
                        .padding(.trailing)

                        
                    }
                    Spacer()
                }
                .background(Color.gray400)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 14)
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
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

