//
//  ScheduleExVM.swift
//  limber
//
//  Created by 양승완 on 7/8/25.
//

import Combine
import SwiftUI

class ScheduleExVM: ObservableObject {
    
    
    @Published var textFieldName: String = ""
    @Published var selectedCategory: String = ""
    @Published var categorys: [String] = ["학습","업무","회의","직업","기타"]

    @Published var timeSelect: [String] = ["시작", "종료", "반복"]
    @Published var allTime: [String] = [
        "",
        "",
        ""]

    @Published var changeSheet = false
    @Published var bottomSheetTitle = "시작"
    @Published var isStartTime = false
    @Published var isTime = false
    
    @Published var selectedMinute = 0
    @Published var selectedHour = 0
    @Published var selectedAMPM = ""
    
    @Published var startTime = ""
    @Published var finishTime = ""
    @Published var repeatTime = ""
    
    //SheetConfigure
    @Published var detents: PresentationDetent = .height(700)
    @Published var heights: Set<PresentationDetent> = [.height(700)]
    
    
    //MARK: RepeatView
    @Published var repeatOptions = ["매일", "평일", "주말"]
    @Published var selectedDays: Set<String> = []
    @Published var weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    @Published var selectedOption: String? = nil

    //MARK: BottomBtn
    @Published var scheduleExBtnEnable = false
    @Published var timeBtnEnable = false
    @Published var repeatBtnEnable = false
    
    //Binding
    init() {
        $allTime.allSatisfy { !(!$0.isEmpty) }
            .assign(to: &$scheduleExBtnEnable)
        
        $selectedDays
              .map { !$0.isEmpty }
              .assign(to: &$repeatBtnEnable)
        
        Publishers.CombineLatest($selectedMinute, $selectedHour)
            .map { m, h in
                m != 0 || h != 0
            }
            .assign(to: &$timeBtnEnable)
        
        Publishers.CombineLatest3($selectedCategory, $textFieldName, $allTime)
            .map { category, text, allTime in
                !category.isEmpty && !text.isEmpty && !allTime.isEmpty
            }.assign(to: &$scheduleExBtnEnable)
        
        
        //TODO: 시간 쪽 bottomBtn 이랑 월~일 sort
    }

    func on432() {
        heights = [.height(700),.height(432)]
        detents = .height(432)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.heights = [.height(432)]

        })
    }
      
    func on700() {
        self.allTime[2] = selectedDays.reduce("") { $0 + " " + $1 }
        heights = [.height(700), .height(432)]
        detents = .height(700)
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.heights = [.height(700)]

        })

    }
    func onReset() {
        heights = [.height(700)]
        detents = .height(700)
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
        self.on432()
        changeSheet = true
    }
    
    func reset() {
        changeSheet = false
        bottomSheetTitle = "시작"
        isStartTime = false
        isTime = false
    }
    
    func timePicked() {
        if isTime {
            if isStartTime {
                allTime[0] = "\(selectedHour) 시 \(selectedMinute) 분"
            } else {
                allTime[1] = "\(selectedHour) 시 \(selectedMinute) 분"
            }
        }
        
    }
    
    func repeatPicked() {
        allTime[2] = "\(repeatTime)"
    }
    
    func goBack700H() {
        on700()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.heights = [.height(700)]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.changeSheet = false
        }
    }
    
}
