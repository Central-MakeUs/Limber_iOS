//
//  FocusTypeRequestDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//


import Foundation
struct FocusTypeRequestDto: Codable {
    let userId: Int
    let title: String
    let sequence: Int
}
