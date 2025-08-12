//
//  iconLabelStyle.swift
//  limber
//
//  Created by 양승완 on 8/12/25.
//

import SwiftUI


struct iconLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.icon
  }
}
struct textLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.title
  }
}
