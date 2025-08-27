//
//  NetworkManager.swift
//  limber
//
//  Created by 양승완 on 8/27/25.
//

import Foundation

protocol NetworkManagerP {
  func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
  func requestValidated<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkManager: NetworkManagerP {
  
  private let session: URLSession
  private let decoder: JSONDecoder
  init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
    self.session = session
    self.decoder = decoder
  }
  
  //Decodable 타입만
  func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
    let (data, res) = try await session.data(for: endpoint.urlRequest)
    try validate(response: res)
    return try decoder.decode(T.self, from: data)
  }
  //Response Wrapping
  func requestValidated<T: Decodable>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
    let (data, res) = try await session.data(for: endpoint.urlRequest)
    try validate(response: res)
    let wrapper = try decoder.decode(APIResponse<T>.self, from: data)
    return wrapper.data
  }
  
  private func validate(response: URLResponse) throws {
    guard let http = response as? HTTPURLResponse else { return }
    guard 200..<300 ~= http.statusCode else {
      throw TimerRepositoryError.httpError(code: http.statusCode)
    }
  }
  
}


