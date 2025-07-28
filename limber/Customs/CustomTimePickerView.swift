//
//  CustomTimePickerView.swift
//  limber
//
//  Created by 양승완 on 7/3/25.
//
import UIKit
import SwiftUI
struct CustomTimePickerView: UIViewRepresentable {
    
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    

    var hourText: String

    
    var hourRange = Array(0...23)
    let minuteRange = Array(0...59)
    
   

    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        let hourLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        hourLabel.text = hourText
        
        let minuteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        minuteLabel.text = "분"
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 200))
        
        pickerView.delegate = context.coordinator
        pickerView.dataSource = context.coordinator
        
        pickerView.selectRow(selectedHour, inComponent: 0, animated: false)
        pickerView.selectRow(selectedMinute, inComponent: 1, animated: false)
        
        view.addSubview(pickerView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        pickerView.setPickerLabels(labels: [0:hourLabel, 1: minuteLabel], containedView: view)
        
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func updateUIView(_ uiView: UIView, context: Context) {
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
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat { 110 }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { 40 }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 {
                
                parent.selectedHour = parent.hourRange[row]
            } else {
                parent.selectedMinute = parent.minuteRange[row]
            }
        }
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            if #available(iOS 14.0, *) {
                pickerView.subviews[1].backgroundColor = .clear
            }
            
            let label = UILabel()
            if component == 0 {
                label.text = "\(parent.hourRange[row])"
            } else {
                label.text = "\(parent.minuteRange[row])"

            }
    
            label.textAlignment = .center
            label.backgroundColor = .clear
            
            label.font = UIFont(name: "SUIT-SemiBold", size: 24)
            label.textColor = .black
            
            return label
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

extension UIPickerView{
    func setPickerLabels(labels: [Int:UILabel], containedView: UIView) {
        
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = containedView.bounds.width / CGFloat(self.numberOfComponents)
        
        let x: CGFloat = self.frame.origin.x
        let y: CGFloat = (self.frame.size.height / 2) - 2
        
        for i in 0...self.numberOfComponents {
            if let label = labels[i] {
                if label.text!.count == 2 {
                    label.frame = CGRect(x: x + labelWidth * CGFloat(0) + 68, y: y, width: labelWidth, height: fontSize)
                } else {
                    label.frame = CGRect(x: x + labelWidth * CGFloat(1) + 26, y: y, width: labelWidth, height: fontSize)
                }
                
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                label.font = UIFont(name: "SUIT-SemiBold", size: 24)
                label.textColor = .black
                self.addSubview(label)
            }
        }
    }
}

struct AmPmPickerWrapper: UIViewRepresentable {
    @State var selectedRow: Int = 0
    @Binding var selectedData: String
    let data: [String] = ["오전", "오후"]

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
        uiView.selectRow(selectedRow, inComponent: 0, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: AmPmPickerWrapper

        init(_ parent: AmPmPickerWrapper) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return parent.data[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selectedRow = row
            parent.selectedData = parent.data[row]
        }
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            if #available(iOS 14.0, *) {
                pickerView.subviews[1].backgroundColor = .clear
            }
            let label = UILabel()
            
            label.text = "\(parent.data[row])"
            label.textAlignment = .center
            label.backgroundColor = .clear
            
            label.font = UIFont(name: "SUIT-SemiBold", size: 24)
            label.textColor = .black
            
            return label
        }
        
        func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            if #available(iOS 14.0, *) {
                pickerView.subviews[1].backgroundColor = .clear
            }
            return nil
        }
    }
}


