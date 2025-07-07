//
//  BottomSheet700H.swift
//  limber
//
//  Created by 양승완 on 7/7/25.
//

import SwiftUI

struct BottomSheet700H: View {
    @State var isSelect = false
    var body: some View {
        ZStack {
            if isSelect {
                TimeSelectView()
            } else {
                RepeatView()
            }
        }
        BottomBtn(title: "완료", action: {
            
        })
    }
}
