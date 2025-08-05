//
//  TokenRequestDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//

import Foundation


// MARK: - Protocol

protocol TokenRepositoryProtocol {
    /// 리프레시 토큰으로 새로운 액세스 토큰 발급
    func refresh(request: TokenRequestDto) async throws -> TokenPairDto
}

// MARK: - Repository 구현

final class TokenRepository: TokenRepositoryProtocol {
    private let baseURL = URL(string: "https://your.api.server/api/users")!
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    init(session: URLSession = .shared) {
        self.session = session
        self.jsonDecoder = JSONDecoder()
        self.jsonEncoder = JSONEncoder()
    }

    func refresh(request dto: TokenRequestDto) async throws -> TokenPairDto {
        let url = baseURL.appendingPathComponent("refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try jsonEncoder.encode(dto)

        let (data, response) = try await session.data(for: request)
        try validate(response: response)
        return try jsonDecoder.decode(TokenPairDto.self, from: data)
    }

    /// HTTP 응답 상태 코드 검증 (200–299 이외는 오류 던짐)
    private func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
    }
}
