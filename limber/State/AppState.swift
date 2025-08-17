//
//  AppState.swift
//  limber
//
//  Created by 양승완 on 7/17/25.
//

import UIKit
import ManagedSettings


class AppState: ObservableObject {
    @Published var navigateToDetail = false
    @Published var detailId: Int?
}
