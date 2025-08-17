//
//  FontManager.swift
//  limber
//
//  Created by 양승완 on 7/1/25.
//

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
  static var suitDisplay1: Font { .custom("SUIT-SemiBold", size: 41) }
  static var suitDisplay2: Font { .custom("SUIT-SemiBold", size: 29) }
  
  static var suitHeading1: Font { .custom("SUIT-SemiBold", size: 25) }
  static var suitHeading1_1: Font { .custom("SUIT-SemiBold", size: 23) }
  
  static var suitHeading2: Font { .custom("SUIT-SemiBold", size: 21) }
  static var suitHeading3: Font { .custom("SUIT-SemiBold", size: 19) }
  static var suitHeading3Small: Font { .custom("SUIT-SemiBold", size: 17) }
  
  
  static var suitBody1: Font { .custom("SUIT-Medium", size: 17) }
  static var suitBody2: Font { .custom("SUIT-Medium", size: 15) }
  static var suitBody2_sb: Font { .custom("SUIT-SemiBold", size: 15) }
  static var suitBody3: Font { .custom("SUIT-Medium", size: 13) }
  
  static var suitCaption1: Font { .custom("SUIT-Medium", size: 11) }
}
