//
//  MainView.swift
//  limber
//
//  Created by 양승완 on 6/25/25.
//

import SwiftUI

struct TimerView: View {
    @State private var selectedTime = Date()

    @State var hours: Int = 1
    @State var minutes: Int = 1

    @State private var duration: TimeInterval = 1500   // 25분

        
    var body: some View {
   
           
            

            ZStack {
                
                
                Rectangle()
                          .frame(width: 240, height: 40)
                          .foregroundStyle(Color.plustoGray.opacity(1))
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CustomTimePickerView(selectedHour: $hours, selectedMinute: $minutes)
                            
                        Spacer()
                        
                    }
                    Spacer()
                }
             
                
//                HStack {
//                    Text("시간")
//                        .offset(x: 180)
//                    Spacer()
//                    Text("분")
//                        .offset(x: -100)
//
//                }
           
//                CountDownPickerView(duration: $duration)
//
            }
      
       
    }
            
        
    }
    
 
#Preview {
    TimerView()
}


struct CustomTimePickerView: UIViewRepresentable {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int

    let hourRange = Array(0...24)
    let minuteRange = Array(0...60)

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // ⭐️ 여기서 UIView 리턴
    func makeUIView(context: Context) -> UIView {
        let stack = UIView()
    
        let hourLabel = UILabel()
        hourLabel.text = "시간"
        hourLabel.textAlignment = .center
        hourLabel.widthAnchor.constraint(equalToConstant: 36).isActive = true

        let pickerView = UIPickerView()
        pickerView.delegate = context.coordinator
        pickerView.dataSource = context.coordinator
        pickerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        
        

        let minuteLabel = UILabel()
        minuteLabel.text = "분"
        minuteLabel.textAlignment = .center
        minuteLabel.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        minuteLabel.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        hourLabel.translatesAutoresizingMaskIntoConstraints = false

        
        pickerView.backgroundColor = .lightGray.withAlphaComponent(0.2)

        // 원하는 순서대로 추가
        stack.addSubview(pickerView)
        stack.addSubview(hourLabel)
        stack.addSubview(minuteLabel)
        
        pickerView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 120).isActive = true


       
        
       
        pickerView.selectRow(selectedHour, inComponent: 0, animated: false)
        pickerView.selectRow(selectedMinute, inComponent: 1, animated: false)
        
        
       
        
        pickerView.centerYAnchor.constraint(equalTo: stack.centerYAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: stack.centerXAnchor).isActive = true
        
        
        
        
        hourLabel.widthAnchor.constraint(equalToConstant: 36).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor).isActive = true
        hourLabel.leadingAnchor.constraint(equalTo:         pickerView.subviews[0].subviews[0]
            .trailingAnchor, constant: 0).isActive = true
        
        
        minuteLabel.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        minuteLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor).isActive = true
        
        minuteLabel.leadingAnchor.constraint(equalTo: pickerView.subviews[0].subviews[1]
            .trailingAnchor, constant: 0).isActive = true
      
        return stack
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // stackView의 두 번째 뷰가 pickerView임을 가정
        if let stack = uiView as? UIStackView,
           let pickerView = stack.arrangedSubviews.first(where: { $0 is UIPickerView }) as? UIPickerView {
            pickerView.selectRow(selectedHour, inComponent: 0, animated: false)
            pickerView.selectRow(selectedMinute, inComponent: 1, animated: false)
        }
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomTimePickerView

        init(_ parent: CustomTimePickerView) { self.parent = parent }

        func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            component == 0 ? parent.hourRange.count : parent.minuteRange.count
        }
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat { 80 }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { 40 }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 {
                parent.selectedHour = parent.hourRange[row]
            } else {
                parent.selectedMinute = parent.minuteRange[row]
            }
        }
        func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            if #available(iOS 14.0, *) {
                pickerView.subviews[1].backgroundColor = .clear
                
            }
            let text = component == 0 ? "\(parent.hourRange[row])" : "\(parent.minuteRange[row])"
            return NSAttributedString(string: text, attributes: [.foregroundColor: UIColor.black])
        }
    }
}
