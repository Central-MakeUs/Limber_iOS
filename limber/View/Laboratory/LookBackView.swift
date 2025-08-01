//
//  LookBackView.swift
//  limber
//
//  Created by 양승완 on 7/30/25.
//
import SwiftUI
struct LookBackView: View {
    
    @ObservedObject var labVM: LabVM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(labVM.experiments) { experiment in
                    HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(experiment.dateText)
                                    .font(.suitBody2)
                                    .foregroundColor(.gray500)
                                
                                HStack(spacing: 0) {
                                    Text(experiment.category)
                                        .foregroundColor(.limberPurple)
                                    Text("에 집중한 실험")
                                        .foregroundColor(.black)
                                }
                                .font(.suitHeading3Small)
                                
                                Spacer()
                                
                                if let description = experiment.description {
                                    Text(description)
                                        .font(.suitBody2)
                                        .foregroundColor(.gray700)
                                }
                            }
                            .padding(20)
                        
                            Spacer()
                        VStack {
                            ZStack(alignment: .center) {
                                Circle()
                                    .frame(width: 56, height: 56)
                                    .foregroundStyle(Color.primaryVivid)
                                
                                Image(experiment.iconName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                
                                if let progress = experiment.progressText {
                                    Text("20% 집중")
                                        .frame(width: 66, height: 25, alignment: .center)
                                        .font(.suitBody3)
                                        .foregroundStyle(Color.white)
                                        .background(Color.limberPurple)
                                        .cornerRadius(13)
                                        .offset(y: 34)
                                }
                            }
                            .offset(y: -10)
                            .frame(maxHeight: 80)
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 116)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        
    }
}

struct LabExperiment: Identifiable {
    let id = UUID()
    let dateText: String
    let category: String
    let description: String?
    let progressText: String?
    let iconName: String
    let isFaded: Bool
}
