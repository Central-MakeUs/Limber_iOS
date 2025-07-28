//
//  HomeVM.swift
//  limber
//
//  Created by 양승완 on 7/22/25.
//

import Foundation
import DeviceActivity
import SwiftUI


class HomeVM: ObservableObject {
    
    @Published var isTimering: Bool = false
    @Published var timerStr: String = ""

    init() {
        onAppear()
    }
    
    func onAppear() {
        SharedData.defaultsGroup?.set(true, forKey: SharedData.Keys.isTimering.key)

        
        
        isTimering = true

        timerStr = TimeInterval(10000.0).toString()
        
    }
 
}
