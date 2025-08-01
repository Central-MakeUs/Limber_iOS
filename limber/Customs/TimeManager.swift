//
//  Time.swift
//  limber
//
//  Created by 양승완 on 7/31/25.
//

import Foundation
class TimeManager {
    
    static let shared = TimeManager()
    
    func parseTimeString(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "ah시m분ss"
        // 오늘 날짜 기준으로 시간 설정
        let calendar = Calendar.current
        let today = Date()
        
        if let time = formatter.date(from: timeString) {
            let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            
            var combinedComponents = DateComponents()
            
            combinedComponents.year = todayComponents.year
            combinedComponents.month = todayComponents.month
            combinedComponents.day = todayComponents.day
            combinedComponents.hour = timeComponents.hour
            combinedComponents.minute = timeComponents.minute
            combinedComponents.second = timeComponents.second
            
            return calendar.date(from: combinedComponents)
        }
        return nil
        
    }
  
  func timeString(from interval: TimeInterval) -> String {
      let hr = Int(interval) / 3600
      let min = (Int(interval) % 3600) / 60
      let sec = Int(interval) % 60
      return String(format: "%02d:%02d:%02d", hr, min, sec)
  }
  
  func timeStringToDateComponents(_ timeString: String) -> DateComponents? {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.dateFormat = "ah시m분" // 공백 주의 (예: "오후 2시 10분")
      
      guard let date = formatter.date(from: timeString) else {
          return nil
      }
      
      let components = Calendar.current.dateComponents([.hour, .minute], from: date)
      return components
  }

}
