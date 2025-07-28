//
//  ShieldConfigurationExtension.swift
//  ShieldConfigurationEx
//
//  Created by 양승완 on 7/6/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit
import SwiftUI
// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        let defaults = UserDefaults(suiteName: "group.com.limber")
            let isUnlockRequested = defaults?.bool(forKey: "changeView") ?? false
            
            if isUnlockRequested {
                let image = UIImage(named: "앱임시아이콘")
                return ShieldConfiguration(backgroundColor: UIColor(Color(.limberPurple)) , icon: image, title: .init(text: "잠금 해제를 위해\n알림을 눌러 이동해주세요", color: .gray100), subtitle: .init(text: "알림이 잘 보이지 않는다면\n 설정 > 알림 > '림버' 알림 허용을 켜주세요.", color: .gray100), primaryButtonLabel: .init(text: "알림 다시 전송하기", color: .black) , primaryButtonBackgroundColor: .gray100, secondaryButtonLabel: .init(text: "취소", color: .gray100))
                
            } else {
                let image = UIImage(named: "앱임시아이콘")
                return ShieldConfiguration(backgroundColor: UIColor(Color(.limberPurple)) , icon: image, title: .init(text: "차단 중...", color: .gray100), subtitle: .init(text: "집중을 끝까지 이어나가면\n만족스러운 하루가 될거에요.", color: .gray100), primaryButtonLabel: .init(text: "잠금 풀기", color: .black) , primaryButtonBackgroundColor: .gray100, secondaryButtonLabel: .init(text: "계속 집중하기", color: .gray100))
            }
    
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
