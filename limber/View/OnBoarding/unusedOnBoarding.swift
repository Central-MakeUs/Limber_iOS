
//  나중.swift
//  limber
//
//  Created by 양승완 on 7/2/25.

import SwiftUI
@ViewBuilder
   func TopView() -> some View {
       VStack(alignment: .leading) {
           Text("평소 스마트폰의 방해 없이\n집중하고 싶은 순간들을 3개 선택해주세요.")
               .font(Font.system(size: 20, weight: .semibold) )


           Spacer()
               .frame(height: 12)

           Text("선택한 항목은 나중에 언제든지 변경할 수 있어요.")
               .font(Font.system(size: 14, weight: .medium) )
               .foregroundColor(Color(red: 0.4, green: 0.44, blue: 0.52))
       }

   }


//TODO: 2차원배열로 넘기자 VM 에서
@ViewBuilder
   func CenterView() -> some View {
       @State var testArr = [["1","2"], ["3","4"], ["5"]]

       VStack(alignment: .leading) {
           ForEach(0..<testArr.count, id: \.self) { i in
               HStack(spacing: 4) {
                   Text("\(testArr[i][0])")
                       .frame(maxWidth: .infinity, minHeight: 60)
                       .background(Color(red: 0.95, green: 0.96, blue: 0.97))
                       .cornerRadius(4)
                   if testArr[i].count > 1 {
                       Text("\(testArr[i][1])")
                           .frame(maxWidth: .infinity, minHeight: 60)
                           .background(Color(red: 0.95, green: 0.96, blue: 0.97))
                           .cornerRadius(4)
                   } else {
                       Spacer()
                           .frame(width: .infinity)
                   }


               }
               .frame(maxWidth: .infinity)
           }

       }

   }
