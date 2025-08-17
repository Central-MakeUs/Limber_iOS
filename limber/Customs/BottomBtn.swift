//
//  BottomBtn.swift
//  limber
//
//  Created by 양승완 on 7/1/25.
//

import SwiftUI

struct BottomBtn: View {
    
    @Binding var isEnable: Bool
    var title: String
    var action: () -> Void
    let gradient = LinearGradient(
        stops: [
        Gradient.Stop(color: Color(red: 0.73, green: 0.38, blue: 1), location: 0.00),
        Gradient.Stop(color: Color(red: 0.51, green: 0.03, blue: 0.82), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0, y: 0.5),
        endPoint: UnitPoint(x: 1, y: 0.5)
            )
    
    let disabled = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray300, location: 0.00),
        ],
        startPoint: UnitPoint(x: 0, y: 0),
        endPoint: UnitPoint(x: 1, y: 1)
            )
    

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Font.suitHeading3Small)
                .frame(height: 54)
                .frame(maxWidth: .infinity)
                .background(
                    isEnable == true ? gradient : disabled
                )
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.bottom, 4)
        .disabled(!isEnable)

    }
}
