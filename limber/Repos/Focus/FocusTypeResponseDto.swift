//
//  FocusTypeResponseDto.swift
//  limber
//
//  Created by 양승완 on 8/4/25.
//

import Foundation
struct FocusTypeResponseDto: Codable {
    let id: Int
    let title: String
    let userId: Int
    let defaultFlag: String
    let sequence: Int
}
