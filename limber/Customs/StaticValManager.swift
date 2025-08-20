//
//  StaticValManager.swift
//  limber
//
//  Created by 양승완 on 8/17/25.
//


class StaticValManager {
  static let titleDic: [Int: String] = [1:"학습",2:"업무",3:"회의",4:"작업",5:"독서"]
  static let titleCntDic: [String: Int] = ["학습":1,"업무":2,"회의":3,"작업":4,"독서": 5]
  static let titleTextDic: [String] = ["학습","업무","회의","작업","독서"]
  
  static let repeatTitleStrDic: [RepeatCycleCode: String] = [.EVERY:"매일", .WEEKEND:"주말",.WEEKDAY :"평일", .NONE: ""]
}

