//
//  RangeRequest.swift
//  limber
//
//  Created by 양승완 on 8/11/25.
//

import Foundation


struct RangeRequest: Encodable {
  let userId: String
  let startDate: String
  let endDate: String
  
  init(userId: String, start: String, end: String) {
    self.userId = userId
    self.startDate = start
    self.endDate = end
  }
}


