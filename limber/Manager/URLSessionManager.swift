//
//  SubURLS.swift
//  limber
//
//  Created by 양승완 on 7/24/25.
//

import Combine


enum SubURLS: String {
    
    case all = "/all"
}
class URLSessionManager: ObservableObject {
    
    private let baseURL = "https://192.168.0.125/limber"
    
    func setValues() {
        let allUrl = baseURL + SubURLS.all.rawValue
        
    }
}
