//
//  TimerVM.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import Foundation
import SwiftUI
import Combine
struct ExperimentModel: Hashable {
    let category: String
    let title: String
    let timer: String
    let id: UUID = UUID()
    var isOn: Bool
    
    init(category: String, timer: String, title: String, isOn: Bool) {
        self.category = category
        self.timer = timer
        self.title = title
        self.isOn = isOn
    }
    
}

class TimerVM: ObservableObject {
    @EnvironmentObject var router: AppRouter
    
    @Published var categorys: [String] = ["학습","업무","회의","직업","기타"]

    @Published var btnEnable = false
    
    init() {
        $selectedCategory.map { !$0.isEmpty }
                .assign(to: &$btnEnable)
        
    }
    

    @Published var selectingH: Int = 0
    @Published var selectingM: Int = 0
    @Published var selectedCategory: String = ""
    
    @Published var checkedModels: Set<ExperimentModel> = []
    @Published var staticModels: Array<ExperimentModel> = [ExperimentModel(category: "작업", timer: "매일, 오전 8시-9시", title: "포트폴리오 작업하기", isOn: true),ExperimentModel(category: "독서", timer: "주말, 오후 5시 20분-6시 10분", title: "독서 모임용 책 <IT 트렌드 2024> 다 읽기", isOn: false)]

    @Published var timeSelect: [String] = ["시작", "종료", "반복"]
    @Published var allTime: [String] = [
        "오후 5시 36분",
        "오후 10시 32분",
        "2"]
    
    

    @Published var changeSheet = false
    @Published var bottomSheetTitle = "시작"
    @Published var isStartTime = false
    @Published var isTime = false
    
    @Published var isEdit = false
    @Published var isFin = false
    @Published var isAllChecker = false
    
    @Published var delAlert = false
    


    func toggleChanged(id: UUID, newValue: Bool) {
           if let index = staticModels.firstIndex(where: { $0.id == id }) {
               staticModels[index].isOn = newValue
               print("'\(staticModels[index].title)' 토글 상태: \(newValue)")
           }
       }
    
    
    func focusCategoryTapped(idx: Int) {
        switch idx {
        case 0:
            isTime = true
            isStartTime = true
            bottomSheetTitle = "시작"
        case 1:
            isTime = true
            isStartTime = false
            bottomSheetTitle = "종료"
        default:
            isTime = false
            isStartTime = false
            bottomSheetTitle = ""
        }
        
        changeSheet = true
        
    }
    
    func reset() {
        changeSheet = false
        bottomSheetTitle = "시작"
        isStartTime = false
        isTime = false
    }
    
    func allCheckerTapped() {
        isAllChecker.toggle()
        if isAllChecker {
            _ = staticModels.map {
                self.checkedModels.insert($0)
            }
        } else {
            self.checkedModels.removeAll()
        }
    }
    
    func setDeleteSheet() {
        if !checkedModels.isEmpty {
            delAlert = true
        }
    
    }
//    
//    func deleteModels() {
//        staticModels.enumerated().forEach { _,_ in
//            if checkedModels.contains($0) {
//                staticModels.remove
//            }
//        }
//
//    }
    
    

}
