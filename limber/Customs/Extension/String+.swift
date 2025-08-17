//
//  String+.swift
//  limber
//
//  Created by 양승완 on 8/15/25.
//

extension String {
    func appendingSecondsIfNeeded() -> String {
        // HH:mm 형식 체크 (00~23:00~59)
        let regex = #"^\d{2}:\d{2}$"#
        if self.range(of: regex, options: .regularExpression) != nil {
            return self + ":00"
        } else {
            return self
        }
    }
  
  
}
extension String {
  func convertToKor() -> String {
    switch self {
    case "MONDAY":
      return "월"
    case "TUESDAY":
      return "화"
    case "WEDNESDAY":
      return "수"
    case "THURSDAY":
      return "목"
    case "FRIDAY":
      return "금"
    case "SATURDAY":
      return "토"
    default:
      return "일"
    }
  }
}
