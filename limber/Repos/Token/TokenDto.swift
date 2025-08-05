//
//  TokenRequestDto 2.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//



struct TokenRequestDto: Codable {
    let refreshToken: String
}

/// 토큰 페어 응답용 DTO
struct TokenPairDto: Codable {
    let accessToken: String
    let refreshToken: String
}
