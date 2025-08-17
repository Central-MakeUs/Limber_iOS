//
//  HistoryStatus.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation

final class TimerHistoryRepository {
  private let baseURL = URLManager.baseURL.appendingPathComponent("/api/timer-histories")
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
  private let jsonEncoder: JSONEncoder

  init(session: URLSession = .shared) {
    self.session = session
    self.jsonDecoder = JSONDecoder()
    self.jsonEncoder = JSONEncoder()
  }
 
  func getLatestHistory(userId: String, timerId: String) async throws -> TimerHistoryResponseDto? {

    
    var comps = URLComponents(
           url: baseURL.appendingPathComponent("/latest-id"),
           resolvingAgainstBaseURL: false
       )
       comps?.queryItems = [
        URLQueryItem(name: "userId", value: userId),
        URLQueryItem(name: "timerId", value: timerId),
       ]
       guard let url = comps?.url else { throw URLError(.badURL) }

       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       request.setValue("application/json", forHTTPHeaderField: "Accept")

      let (data, response) = try await session.data(for: request)
      try validate(response: response)

    let res = try jsonDecoder.decode(LatestDecoder.self, from: data)
    return res.data
    
  }
  
  func getHistoriesAll(_ dto: TimerHistorySearchDto) async throws -> [TimerHistoryResponseDto] {
    
    var comps = URLComponents(
           url: baseURL.appendingPathComponent("/search"),
//      url: URL(string: "http://3.35.146.79:8888/api/timer-histories/search?userId=14F4568D-AA21-4108-874C-7700915A3D62&searchRange=ALL&onlyIncompleteRetrospect=false")!,
           resolvingAgainstBaseURL: false
       )
       comps?.queryItems = [
           URLQueryItem(name: "userId", value: dto.userId),
           URLQueryItem(name: "searchRange", value: dto.searchRange),
           URLQueryItem(
               name: "onlyIncompleteRetrospect",
               value: dto.onlyIncompleteRetrospect ? "true" : "false"
           ),
       ]
       guard let url = comps?.url else { throw URLError(.badURL) }

       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       request.setValue("application/json", forHTTPHeaderField: "Accept")

      let (data, response) = try await session.data(for: request)
      try validate(response: response)

      let res = try jsonDecoder.decode(TimerHistoryResponse.self, from: data)
      return res.data
  }
  
    /// 공통 HTTP 응답 검증 (200–299 이외는 오류 던짐)
    private func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
    }
}
struct LatestDecoder: Codable {
  let success: Bool
  let data: TimerHistoryResponseDto?
  let error: String?
}
