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
    @Environment(\.dismiss) private var dismiss
    @StateObject var blockVM: BlockVM = BlockVM()
    @ObservedObject var vm: ExampleVM

    @State private var showPicker = false
    @Binding var showModal: Bool
    @State private var isEnable = true
    

    var body: some View {
        
        VStack {
            
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        blockVM.reset()
                        showModal = false
                    }) {
                        Image("xmark")
                    }
                }
                .padding([.top, .trailing], 20)
                
                
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
                    Text("\(blockVM.applicationTokens.count)개")
                        .foregroundColor(Color.limberPurple)
                        .font(.suitHeading2)
                    Text("의 앱이 차단돼요")
                        .foregroundColor(.gray800)
                        .font(.suitHeading2)
                }
            }
            .multilineTextAlignment(.center)
            .padding(.bottom, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(Array(blockVM.applicationTokens.sorted { $0.hashValue < $1.hashValue }), id: \.self) { token in

                        VStack {
                            
                            Label(token)
                                .labelStyle(iconLabelStyle())
                                .scaleEffect(CGSize(width: 1.6, height: 1.6))
                            Label(token)
                                .labelStyle(textLabelStyle())
                                .scaleEffect(CGSize(width: 0.6, height: 0.6))

                                
                        }
                        .cornerRadius(8)
                        .frame(width: 100, height: 76, alignment: .center)
                        .background(Color.gray100)





                    
                            
        
                    }
              

                }
            }
            .frame(height: 76)
            .padding([.bottom, .horizontal], 16)
            
            Button {
                blockVM.reset()
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
            Spacer()
            
            Text("버튼을 누르면 실험이 시작돼요")
                .foregroundColor(.gray500)
                .font(.system(size: 15))
                .padding(.bottom, 8)
            
                
            BottomBtn(isEnable: $isEnable, title: "시작하기") {
                blockVM.setShieldRestrictions()
                dismiss()
                }
                .padding(20)
        }
        .frame(height: 515)
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal, 20)
        
    }.background(ClearBackground())
        .sheet(isPresented: $showPicker) {
            BlockBottomSheet(isOnboarding: false, vm: blockVM, onComplete: {})
                .presentationDetents([.height(700),])
                .presentationCornerRadius(24)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 4)
        }
        .onAppear {
            blockVM.reset()
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
struct iconLabelStyle: LabelStyle {
        
    func makeBody(configuration: Configuration) -> some View {

            configuration.icon
            
    }
}
struct textLabelStyle: LabelStyle {
        
    func makeBody(configuration: Configuration) -> some View {
            configuration.title
            .frame(height: 40)
    }
}


#Preview {
    BlockAppsSheet(vm: ExampleVM(), showModal: .init(get: {
        true
    }, set: {_ in }))
}
