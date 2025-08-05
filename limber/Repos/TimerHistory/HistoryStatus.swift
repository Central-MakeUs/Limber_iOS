//
//  HistoryStatus.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//



// MARK: - Enum

enum HistoryStatus: String, Codable {
    case sent   = "SENT"   // 전송 완료
    case failed = "FAILED" // 전송 실패
}
