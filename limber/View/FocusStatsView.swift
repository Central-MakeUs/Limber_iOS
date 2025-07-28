//
//  FocusStatsView.swift
//  limber
//
//  Created by 양승완 on 7/28/25.
//


import SwiftUI
import Charts
struct FocusStatsView: View {
    let days = ["월", "화", "수", "목", "금", "토", "일"]
    let hours: [Double] = [6.5, 6.1, 6.0, 6.3, 0.2, 0.0, 0.0] // 대략적 예시 데이터

    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 상단 정보
                VStack(alignment: .leading, spacing: 4) {
                    Text("총 실험 시간")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("10시간 20분")
                        .font(.title)
                        .bold()
                    Text("2025년 06월 23일–29일")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // 막대 그래프
                WeeklyDataView()
                
                // 선택 버튼
                HStack {
                    Spacer()
                    Text("집중 시간")
                        .fontWeight(.bold)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .shadow(radius: 2)
                    
                    Text("몰입도")
                        .foregroundColor(.gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(Capsule())
                    Spacer()
                }
                
                // 하단 통계 카드
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                        Text("평균 집중 시간")
                            .font(.suitBody2)
                            .foregroundColor(.limberPurple)
                        Text("10시간 20분")
                            .bold()
                    }
                    .frame(maxWidth: .infinity, minHeight: 132)
                    .background(.limerLightPurple)
                    .cornerRadius(10)

                    
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "flame.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                        Text("평균 집중 몰입도")
                            .font(.suitBody2)
                            .foregroundColor(.limberPurple)
                        Text("49%")
                            .bold()
                    }
                    .frame(maxWidth: .infinity, minHeight: 132)
                    .background(.limerLightPurple)
                    .cornerRadius(10)

                }


                StudyInsightView()
                
                Spacer().frame(height: 20)

                StopReasonView()
                
                Spacer()
            }
            .padding(20)
        }
    }
}

struct WeeklyDataView: View {
    let weeklyData = [
        (day: "월", value: 5),
        (day: "화", value: 5),
        (day: "수", value: 4),
        (day: "목", value: 5),
        (day: "금", value: 1),
        (day: "토", value: 0),
        (day: "일", value: 0)
    ]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(weeklyData, id: \.day) { item in
                    BarMark(
                        x: .value("요일", item.day),
                        y: .value("값", item.value),
                        width: .fixed(24)
                    )
                    .foregroundStyle(Color.purple.opacity(0.4))
                    .cornerRadius(6)
                }
            }
            .chartYScale(domain: 0...24)
            .chartYAxis {
                AxisMarks(position: .leading, values: .stride(by: 6)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(.gray.opacity(0.3))
                    AxisTick()
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)h")
                                .font(.caption)
                                .foregroundColor(.gray400)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let stringValue = value.as(String.self) {
                            Text(stringValue)
                                .font(.caption)
                                .foregroundColor(.gray400)
                        }
                    }
                }
            }
            .frame(height: 200)
        }
    }
}


struct StudyInsightView: View {
    let studyData = [
        StudyItem(
            icon: "pencil.circle.fill",
            title: "학습",
            duration: "4시간 12분",
            progress: 0.8,
            color: Color.purple
        ),
        StudyItem(
            icon: "briefcase.fill",
            title: "업무",
            duration: "3시간 10분",
            progress: 0.6,
            color: Color.blue
        ),
        StudyItem(
            icon: "book.fill",
            title: "독서",
            duration: "2시간",
            progress: 0.4,
            color: Color.cyan
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 헤더
            HStack {
                Text("실험 인사이트")
                    .font(.suitHeading3Small)
                    .foregroundColor(.gray500)
                Spacer()
            }
            .padding([.top, .bottom], 20)
            
            // 메인 카드
            VStack(alignment: .leading, spacing: 24) {
                // 제목 섹션
                VStack(alignment: .leading, spacing: 0) {
                    Text("가장 몰입한 상황은")
                        .font(.suitHeading2)
                        .foregroundColor(.gray800)
                    
                    HStack(spacing: 0) {
                        Text("학습")
                            .font(.suitHeading2)
                            .foregroundColor(.limberPurple)
                        Text("이에요")
                            .font(.suitHeading2)
                            .foregroundColor(.gray800)
                    }
                    Spacer()
                        .frame(height: 12)
                    Text("전체 집중 시간의 50%를 차지했어요.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                VStack(spacing: 20) {
                    ForEach(studyData, id: \.title) { item in
                        StudyProgressRow(item: item)
                    }
                }
                .padding(24)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
            
            Spacer()
        }

    }
}

struct StudyProgressRow: View {
    let item: StudyItem
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(item.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(item.color)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(item.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(item.duration)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // 배경 바
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.color)
                            .frame(width: geometry.size.width * item.progress, height: 8)
                    }
                }
                .frame(height: 8)
            }
        }
    }
}

struct StudyItem {
    let icon: String
    let title: String
    let duration: String
    let progress: Double
    let color: Color
}

struct StopReasonView: View {
    let studyData = [
        StudyItem(
            icon: "pencil.circle.fill",
            title: "집중 의지가 부족해요",
            duration: "4회",
            progress: 0.8,
            color: Color.purple
        ),
        StudyItem(
            icon: "briefcase.fill",
            title: "휴식이 필요해요",
            duration: "3회",
            progress: 0.6,
            color: Color.blue
        ),
        StudyItem(
            icon: "book.fill",
            title: "긴급한 상황이 발생했어요",
            duration: "1회",
            progress: 0.4,
            color: Color.cyan
        )
    ]
    
    var body: some View {
  
            VStack(alignment: .leading, spacing: 24) {
                // 제목 섹션
                VStack(alignment: .leading, spacing: 0) {
                    Text("가장 몰입한 상황은")
                        .font(.suitHeading2)
                        .foregroundColor(.gray800)
                    
                    HStack(spacing: 0) {
                        Text("학습")
                            .font(.suitHeading2)
                            .foregroundColor(.limberPurple)
                        Text("이에요")
                            .font(.suitHeading2)
                            .foregroundColor(.gray800)
                    }
                    Spacer()
                        .frame(height: 12)
                    Text("전체 집중 시간의 50%를 차지했어요.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                VStack(spacing: 20) {
                    ForEach(studyData, id: \.title) { item in
                        StudyProgressRow(item: item)
                    }
                }
                .padding(24)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
            
            Spacer()

    }
}

#Preview {
    FocusStatsView()
}
