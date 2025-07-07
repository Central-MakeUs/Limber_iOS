//
//  BottomSheet700H.swift
//  limber
//
//  Created by 양승완 on 7/7/25.
//

import SwiftUI

struct BottomSheet4320H: View {
    @State var isTime: Bool
    @State var isStartTime: Bool
    @State var title = "시작"
    var onComplete: () -> Void
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
                if isTime {
                    
                    if isStartTime {
                        TimeSelectView(title: "시작")

                    } else {
                        TimeSelectView(title: "종료")

                    }

                    Spacer()

                } else {
                    RepeatView()
                    Spacer()

                }
            
            BottomBtn(title: "완료", action: {
                
            })
        }
    }
}
