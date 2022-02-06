//
//  TraningView.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 06.02.2022.
//

import SwiftUI

struct WordForTraningView: View {
    @Binding var isVisible: Bool
    @Binding var group: WordGroup
    
    var body: some View {
        if isVisible {
            TabView() {
                ForEach(group.wordList, id: \.onEnglish) { word in
                    VStack(spacing: 30) {
                        Text(word.onEnglish)
                        Text(word.onRussian)
                        Text(word.transcription)
                    }
                    .font(.largeTitle)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .overlay(
                Button(action: {
                    withAnimation {
                        isVisible = false
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                })
                    .padding()
                ,alignment: .topTrailing
            )
            .transition(.move(edge: .bottom))
        }
    }
}

struct TraningView_Previews: PreviewProvider {
    static var previews: some View {
        WordForTraningView(isVisible: .constant(true), group: .constant( WordGroup(name: "Group1", wordList: [
            Word(isLearned: false, onEnglish: "Kat", onRussian: "Кошечка"),
            Word(isLearned: false, onEnglish: "Kat2", onRussian: "Кошечка2")
        ])))
    }
}
