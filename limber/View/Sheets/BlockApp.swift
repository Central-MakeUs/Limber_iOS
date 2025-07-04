//
//  BlockedAppSheet.swift
//  limber
//
//  Created by 양승완 on 7/4/25.
//

import SwiftUI
import DeviceActivity
import FamilyControls

struct BlockAppsSheet: View {
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    @State var filter: DeviceActivityFilter
    var fam = FamilyActivitySelection(includeEntireCategory: true)
    let duration: String = "1시간 4분"
    let appCount: Int = 8
    let blockedApps: [BlockedApp] = [
        BlockedApp(name: "인스타그램", image: "instagram"),
        BlockedApp(name: "유튜브", image: "youtube"),
        BlockedApp(name: "카카오톡", image: "kakao")
    ]
 
    var body: some View {
        VStack(spacing: 0) {
            VStack {
            HStack {
                Spacer()
                Button(action: {
                    
                }) {
                    Image("xmark")
                }
            }
            .padding([.top, .trailing], 20)
            
            Spacer().frame(height: 16)

                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 100, height: 100)
                    Text("실험 그래픽")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                
                
                Spacer().frame(height: 16)
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray200)
           
            Spacer().frame(height: 28)

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("\(duration)")
                        .foregroundColor(Color.limberPurple)
                        .font(.suitHeading2)
                    Text("동안")
                        .foregroundColor(.gray800)
                        .font(.suitHeading2)
                }
                .padding(.bottom, 2)

                HStack(spacing: 0) {
                    Text("\(appCount)개")
                        .foregroundColor(Color.limberPurple)
                        .font(.suitHeading2)
                    Text("의 앱이 차단돼요")
                        .foregroundColor(.gray800)
                        .font(.suitHeading2)
                }
  
            }
            .multilineTextAlignment(.center)
            .padding(.bottom, 32)

            // 앱 리스트
            HStack(spacing: 16) {
//                ForEach(blockedApps) { app in
//                    VStack(spacing: 8) {
//                        Image(app.image) // 실제 이미지 리소스 필요
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .cornerRadius(8)
//                        Text(app.name)
//                            
//                    }
//                    .frame(width: 100, height: 76)
//                }
                DeviceActivityReport(context, filter: filter)
                    

            }
            .padding(.bottom, 16)
            
            HStack(spacing: 8) {
                Spacer()
                Image(systemName: "pencil")
                    .foregroundColor(.gray500)
                Text("편집하기")
                    .foregroundColor(.gray500)
                    .font(.system(size: 15))
                Spacer()
            }
            .padding(.bottom, 12)

            // 안내 문구
            Text("버튼을 누르면 실험이 시작돼요")
                .foregroundColor(.gray500)
                .font(.system(size: 15))
                .padding(.bottom, 8)
            
            Button(action: {
                // 시작 액션
            }) {
                Text("시작하기")
                    .font(.system(size: 19, weight: .bold))
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color.limberPurple)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .padding(24)
        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 4)
    }
        
}

struct BlockedApp: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

// 프리뷰
#Preview {
    BlockAppsSheet(filter: .init())
}
