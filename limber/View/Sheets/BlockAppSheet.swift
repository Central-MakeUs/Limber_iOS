//
//  BlockedAppSheet.swift
//  limber
//
//  Created by 양승완 on 7/4/25.
//

import SwiftUI
import DeviceActivity
import FamilyControls

struct BlockAppsSheet: View {
    @EnvironmentObject var router: AppRouter
    @StateObject var pickerVM: BlockVM = BlockVM()
    @ObservedObject var vm: ExampleVM
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    @State private var showPicker = false
    @Binding var showModal: Bool
    
    let appCount: Int = 8
 
    var body: some View {
        
        VStack {
            
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showModal = false
                    }) {
                        Image("xmark")
                    }
                }
                .padding([.top, .trailing], 20)
                
                Spacer().frame(height: 16)
                
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 100, height: 100)
                    Text("실험 그래픽")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                Spacer().frame(height: 16)
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray200)
            
            Spacer().frame(height: 28)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("1시간 4분")
                        .foregroundColor(Color.limberPurple)
                        .font(.suitHeading2)
                    Text("동안")
                        .foregroundColor(.gray800)
                        .font(.suitHeading2)
                }
                HStack(spacing: 0) {
                    Text("\(appCount)개")
                        .foregroundColor(Color.limberPurple)
                        .font(.suitHeading2)
                    Text("의 앱이 차단돼요")
                        .foregroundColor(.gray800)
                        .font(.suitHeading2)
                }
            }
            .multilineTextAlignment(.center)
            .padding(.bottom, 32)
            
            HStack(spacing: 0) {
                Spacer()
                DeviceActivityReport(context, filter: vm.filter)
                    .foregroundColor(.black)
           
                  
                Spacer()
            }
            .frame(height: 76)
            .padding(16)
            
            Button {
                showPicker = true
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    Image( "pencil")
                        .resizable()
                        .frame(width: 16,height: 16)
                        .foregroundColor(.gray500)
                    
                    Text("편집하기")
                        .foregroundColor(.gray500)
                        .font(.system(size: 15))
                    Spacer()
                }
                .padding(.bottom, 12)
            }
            
            
            Text("버튼을 누르면 실험이 시작돼요")
                .foregroundColor(.gray500)
                .font(.system(size: 15))
                .padding(.bottom, 8)
            
            Button(action: {
                // 시작 액션
            }) {
                Text("시작하기")
                    .font(.system(size: 19, weight: .bold))
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color.limberPurple)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal, 24)
        
    }.background(ClearBackground())
        .sheet(isPresented: $showPicker) {
            BlockBottomSheet(vm: pickerVM, onComplete: {})
                .presentationDetents([.height(700),])
                .presentationCornerRadius(24)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 4)

        }
        
   
    
        
    }
        
}

struct BlockedApp: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}
struct ClearBackground: UIViewRepresentable {
    
    public func makeUIView(context: Context) -> UIView {
        
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}

class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}
