//
//  TimerRetrospectResponse.swift
//  limber
//
//  Created by 양승완 on 8/27/25.
//



// MARK: - Response
struct TimerRetrospectResponse: Decodable {
  let data: [TimerRetrospectResponseDto]
  
  private enum CodingKeys: String, CodingKey {
    case data
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let array = try? container.decode([TimerRetrospectResponseDto].self, forKey: .data) {
      self.data = array
    }
    else if let single = try? container.decode(TimerRetrospectResponseDto.self, forKey: .data) {
      self.data = [single]
    }
    else {
      self.data = []
    }
  }
}
