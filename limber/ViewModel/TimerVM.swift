//
//  TimerVM.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import Foundation
import SwiftUI


class TimerVM: ObservableObject {
    @EnvironmentObject var router: AppRouter
    @Published var selectingH: Int = 0
    @Published var selectingM: Int = 0
    @Published var selectedCategory: String = ""
    @Published var categorys: [String] = ["더보기"]
    
    @Published var checkedModels: Set<ExperimentModel> = []
    @Published var staticModels: Array<ExperimentModel> = [ExperimentModel(category: "작업", title: "포트폴리오 작업하기", timer: "매일, 오전 8시-9시"),ExperimentModel(category: "독서", title: "독서 모임용 책 <IT 트렌드 2024> 다 읽기", timer: "주말, 오후 5시 20분-6시 10분")]

    @Published var timeSelect: [String] = ["시작", "종료", "반복"]
    @Published var allTime: [String] = [
        "오후 5시 36분",
        "오후 10시 32분",
        "2"]
    
    @Published var startTimePick = false
    @Published var finTimePick = false
    @Published var repeatPick = false
    @Published var changeSheet = false


    func focusCategoryTapped(idx: Int) {
        switch idx {
        case 0:
            startTimePick = true
        case 1:
            finTimePick = true
        default:
            repeatPick = true
        }
        
        changeSheet = true
        
    }
    
    
    
}


extension TimerVM {
}
