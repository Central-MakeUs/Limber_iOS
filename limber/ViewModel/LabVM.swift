//
//  LabVM.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//

import Foundation

class LabVM: ObservableObject {
    @Published var weeklyData = [
        (day: "월", value: 5),
        (day: "화", value: 5),
        (day: "수", value: 4),
        (day: "목", value: 5),
        (day: "금", value: 1),
        (day: "토", value: 0),
        (day: "일", value: 0)
    ]
    
    @Published var experiments: [LabExperiment] = [
        LabExperiment(dateText: "오늘, 1시간 30분", category: "학습", description: "포트폴리오 작업하기", progressText: "20% 집중", iconName: "note", isFaded: false),
        LabExperiment(dateText: "오늘, 1시간 30분", category: "학습", description: nil, progressText: "20% 집중", iconName: "note", isFaded: false),
        LabExperiment(dateText: "어제, 1시간 30분", category: "학습", description: "포트폴리오 작업하기", progressText: nil, iconName: "note", isFaded: true),
        LabExperiment(dateText: "12일 전, 2시간 3분", category: "학습", description: nil, progressText: "회고하기", iconName: "note", isFaded: false)
    ]
    
    @Published var studyData = [
        StudyItem(
            icon: "note",
            title: "학습",
            duration: "4시간 12분",
            progress: 0.8 ),
        StudyItem(
            icon: "bag",
            title: "업무",
            duration: "3시간 10분",
            progress: 0.6 ),
        StudyItem(
            icon: "book",
            title: "독서",
            duration: "2시간",
            progress: 0.4 )
    ]
    
    @Published var reasonData = [
        StudyItem(
            icon: "firstMedal",
            title: "집중 의지가 부족해요",
            duration: "4회",
            progress: 0.8
        ),
        StudyItem(
            icon: "secondMedal",
            title: "휴식이 필요해요",
            duration: "3회",
            progress: 0.6
        ),
        StudyItem(
            icon: "thirdMedal",
            title: "긴급한 상황이 발생했어요",
            duration: "1회",
            progress: 0.2
        )
    ]
    
    @Published var totalTime: String = "10시간 20분"
    @Published var weeklyDate: String = "2025년 06월 23일-29일"
    @Published var averageAttentionTime: String = "10시간 20분"
    @Published var averageAttentionImmersion: String = "49%"
    @Published var toggleIsOn: Bool = false
    
    
}
