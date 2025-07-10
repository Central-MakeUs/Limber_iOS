//
//  BottomSheet700H.swift
//  limber
//
//  Created by 양승완 on 7/7/25.
//

import SwiftUI
import Combine

struct BottomSheet4320H: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = ScheduleExVM()
    @State var isEnabled = false

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            if vm.isTime {
                TimeSelectView(vm: vm)
                Spacer()
                BottomBtn(isEnable: $vm.timeBtnEnable, title: "완료", action: {
                    if vm.isTime {
                        vm.timePicked()
                    } else {
                        vm.repeatPicked()
                    }
                    vm.goBack700H()
                } )
                
            } else {
                RepeatView(vm: vm)
                Spacer()
                BottomBtn(isEnable: $vm.repeatBtnEnable, title: "완료", action: {
                    if vm.isTime {
                        vm.timePicked()
                    } else {
                        vm.repeatPicked()
                    }
                    vm.goBack700H()
                } )
            }
       
            
        }
    }
}
