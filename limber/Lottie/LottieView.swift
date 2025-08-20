//
//  LottieView.swift
//  limber
//
//  Created by 양승완 on 8/20/25.
//


import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
  var onCompleted: (() -> Void)? = nil
  var loopMode: LottieLoopMode = .loop

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
      animationView.play { finished in
                if finished {
                    onCompleted?()
                }
            }
            
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
