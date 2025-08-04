import SwiftUI
import ManagedSettings
import DeviceActivity
import FamilyControls  // 권한 요청을 위해

class DeviceActivityReportVM: ObservableObject {
    /// 보고서에 사용할 컨텍스트
    @Published var contextTotalActivity: DeviceActivityReport.Context
    
    /// 일간/주간/월간 필터
    @Published var filter: DeviceActivityFilter
    
    /// 사용자가 골라볼 날짜
    @Published var pickedDate: Date {
        didSet {
            // 날짜가 바뀌면 daily segment 재설정
            let interval = Calendar.current.dateInterval(of: .day, for: pickedDate)!
            filter = DeviceActivityFilter(segment: .daily(during: interval))
        }
    }
    
    init() {
        // 초기값 세팅
        self.contextTotalActivity = .init(rawValue: "Total Activity")
        self.pickedDate = .now
        self.filter = DeviceActivityFilter(
          segment: .daily(
              during: Calendar.current.dateInterval(
                of: .day,
                  for: .now
              ) ?? DateInterval()
          )
      )
        // 권한이 이미 있다면 무시, 없으면 팝업 띄우기
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            } catch {
                print("Screen Time 권한 요청 실패:", error)
            }
        }
    }
}
