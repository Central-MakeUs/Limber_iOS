//
//  FocusTypesView.swift
//  limber
//
//  Created by 양승완 on 8/13/25.
//

import SwiftUI

struct FocusTypesView: View {
  @Environment(\.dismiss) var dismiss
  @State var showSheet = false
  var body: some View {
    VStack {
      ZStack(alignment: .center) {
        Text("집중 상황")
          .font(.suitHeading3Small)
          .foregroundColor(.black)
        HStack {
          Button(action: {
            dismiss()
          }) {
            Image("backBtn")
              .frame(width: 24, height: 24)
          }
          Spacer()
          
        }
        .padding(.leading, 20)
        
        
      }
      .frame(height: 40)
      
      TagListWithOnMove()
      
      Button {
        showSheet = true
      } label: {
        Text("직접 추가하기")
          .foregroundStyle(.black)
          .font(.suitHeading3Small)
      }
      .frame(height: 54)
      .frame(maxWidth: .infinity)
      .background(.gray200)
      .cornerRadius(10, corners: .allCorners)
      .padding(.horizontal, 20)
    }
    .sheet(isPresented: $showSheet) {
      AutoFocusSheet()
        .presentationDetents([.height(700) ])
        .presentationCornerRadius(24)
        .interactiveDismissDisabled(true)
    }
  }
}

#Preview {
  FocusTypesView()
}


/// 식별자 고정
struct TagItem: Identifiable, Equatable {
  let id: UUID
  var name: String
  var deletable: Bool = false
  
  init(id: UUID = UUID(), name: String, deletable: Bool = false) {
    self.id = id; self.name = name; self.deletable = deletable
  }
}

final class TagVM: ObservableObject {
  @Published var items: [TagItem] = [
    .init(name: "학습"),
    .init(name: "업무"),
    .init(name: "회의"),
    .init(name: "작업"),
    .init(name: "독서"),
    .init(name: "러닝"),
    .init(name: "오픽 공부", deletable: true),
    .init(name: "토익", deletable: true),
    .init(name: "취준", deletable: true)
  ]
  
  func move(from source: IndexSet, to destination: Int) {
    items.move(fromOffsets: source, toOffset: destination)
  }
  
  func delete(_ item: TagItem) {
    if let i = items.firstIndex(where: { $0.id == item.id }), items[i].deletable {
      items.remove(at: i)
    }
  }
}

struct TagListWithOnMove: View {
  @ObservedObject private var vm = TagVM()
  var body: some View {
    List {
      ForEach($vm.items) { $item in
        HStack(spacing: 12) {
          Image(systemName: "line.3.horizontal")
            .foregroundStyle(.secondary)

          Text(item.name)
            .font(.suitBody1)
            .lineLimit(1)

          Spacer()

          if item.deletable {
            Button {
              vm.delete(item)
            } label: {
              ZStack {
                Circle().fill(Color.black.opacity(0.85))
                  .frame(width: 28, height: 28)
                Image(systemName: "xmark")
                  .font(.system(size: 12, weight: .bold))
                  .foregroundStyle(.white)
              }
            }
            .buttonStyle(.plain)
          }
        }
        .listRowInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
        .frame(height: 42)
        .padding(.vertical, 6)
        .listRowSeparator(.hidden)

        .overlay(alignment: .bottom) {
          Rectangle()
            .frame(height: 1 / UIScreen.main.scale)
            .foregroundStyle(.gray.opacity(0.25))
            .ignoresSafeArea()
        }
      }
      .onMove(perform: vm.move)
    }
    .listStyle(.plain)
    
  }
}
