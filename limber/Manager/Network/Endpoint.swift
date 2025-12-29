//
//  Endpoint.swift
//  limber
//
//  Created by 양승완 on 8/27/25.
//
import Foundation

struct Endpoint {
  let path: String
  let method: HTTPMethod
  let query: [URLQueryItem]?
  let body: Encodable?
  
  var urlRequest: URLRequest {
    var url = URLManager.baseURL
    url.appendPathComponent(path)
    if let query = query {
      url = url.appending(queryItems: query)
    }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    if let body = body {
      request.httpBody = try? JSONEncoder().encode(body)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    return request
  }
}
