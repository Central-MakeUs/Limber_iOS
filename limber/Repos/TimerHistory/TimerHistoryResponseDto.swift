//
//  TimerHistoryResponseDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


// MARK: - DTO

struct TimerHistoryResponse: Decodable {
    let data: [TimerHistoryResponseDto]

    private enum CodingKeys: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let array = try? container.decode([TimerHistoryResponseDto].self, forKey: .data) {
            self.data = array
        }
        else if let single = try? container.decode(TimerHistoryResponseDto.self, forKey: .data) {
            self.data = [single]
        }
        else {
            self.data = []
        }
    }
}

struct TimerHistoryResponseDto: Codable, Identifiable {
  let id: Int
  let timerId: Int
  let userId: String
  let title: String
  let focusTypeId: Int
  let repeatCycleCode: String
  let repeatDays: String
  let historyDt: String
  let historyStatus: String
  let failReason: String?
  let startTime: String
  let endTime: String
  let hasRetrospect: Bool
  let retrospectId: Int?
  let retrospectImmersion: Int?
  let retrospectComment: String?
  let focusTypeTitle: String
  let retrospectSummary: String
  
  
  func getImmersionImg() -> String {
    let immersion = retrospectImmersion ?? 0
    return immersion > 20 ? "60Ribbon" : immersion > 60 ? "100Ribbon" : "20Ribbon"
  }

}

struct TimerHistorySearchDto: Codable {
  
  let userId: String
  let searchRange: String
  let onlyIncompleteRetrospect: Bool
    
  
  
}
