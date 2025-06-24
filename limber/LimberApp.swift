//
//  limberApp.swift
//  limber
//
//  Created by 양승완 on 6/23/25.
//

import SwiftUI

@main
struct LimberApp: App {
    // 자식에게 전달해줄 FamlyViewModel StateObject 선언
    @StateObject var vm = ContentVM()
        
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(vm)
                    .onAppear(){
                        
                        Task {
                            do {
                                try await vm.center.requestAuthorization(for: .individual)
                                print("성공")
                            } catch {
                                print("Failed request: \(error)")
                            }
                           
                        }
                    }
            }
        }
}
