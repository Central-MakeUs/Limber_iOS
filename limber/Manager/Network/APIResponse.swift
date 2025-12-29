//
//  APIResponse.swift
//  limber
//
//  Created by 양승완 on 8/27/25.
//

import Foundation


struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T
    let error: String?
}
