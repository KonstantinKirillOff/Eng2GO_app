//
//  EditWordGroupView.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 06.02.2022.
//

import SwiftUI

struct EditWordGroupView: View {
    @EnvironmentObject var wordData: WordViewModel
    
    @Binding var group: WordGroup
    @State private var showTreringView = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("name", text: $group.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 15)
                    .font(.title2)
                Button(action: {
                    print("add word in group")
                }) {
                   Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .padding(.trailing, 10)
                }
            }
            List(group.wordList, id: \.onEnglish) { word in
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(word.onEnglish)")
                    Text("\(word.onRussian)")
                }
                .font(.title2)
            }
            .listStyle(.plain)
            Spacer()
            Button("Start lerning") {
               showTreringView = true
            }
            .frame(width: 300, height: 50)
            .background(Color.blue)
            .cornerRadius(20)
            .foregroundColor(.white)
            .fullScreenCover(isPresented: $showTreringView) {
                WordForTraningView(isVisible: $showTreringView, group: $group)
            }
        }
        .navigationTitle("Edit group")
    }
}

struct EditWordGroupView_Previews: PreviewProvider {
    static var previews: some View {
        EditWordGroupView(group: .constant(WordGroup(name: "Group33", wordList: [Word(isLearned: false, onEnglish: "Squid", onRussian: "Кальмар"), Word(isLearned: false, onEnglish: "Squid2", onRussian: "Кальмар2")])))
    }
}
