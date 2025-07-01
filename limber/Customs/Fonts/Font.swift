//
//  FontManager.swift
//  limber
//
//  Created by 양승완 on 7/1/25.
//

import SwiftUI

import SwiftUI

extension Font {
    static func suit(_ weight: SuitWeight, size: CGFloat) -> Font {
        .custom(weight.rawValue, size: size)
    }

    enum SuitWeight: String {
        case bold = "SUIT-Bold"
        case extraBold = "SUIT-ExtraBold"
        case extraLight = "SUIT-ExtraLight"
        case heavy = "SUIT-Heavy"
        case light = "SUIT-Light"
        case medium = "SUIT-Medium"
        case regular = "SUIT-Regular"
        case semiBold = "SUIT-SemiBold"
        case thin = "SUIT-Thin"
    }
    
    
}
extension Font {
    static var suitDisplay1: Font { .custom("SUIT-SemiBold", size: 40) }
    static var suitDisplay2: Font { .custom("SUIT-SemiBold", size: 28) }
    
    static var suitHeading1: Font { .custom("SUIT-SemiBold", size: 24) }
    static var suitHeading2: Font { .custom("SUIT-SemiBold", size: 20) }
    static var suitHeading3: Font { .custom("SUIT-SemiBold", size: 18) }
    static var suitHeading3Small: Font { .custom("SUIT-SemiBold", size: 16) }
    
    static var suitBody1: Font { .custom("SUIT-Medium", size: 16) }
    static var suitBody2: Font { .custom("SUIT-Medium", size: 14) }
    static var suitBody3: Font { .custom("SUIT-Medium", size: 12) }
    
    static var suitCaption1: Font { .custom("SUIT-Medium", size: 10) }
}
