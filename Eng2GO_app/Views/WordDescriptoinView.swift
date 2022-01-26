//
//  WordDescriptoinView.swift
//  English2Go
//
//  Created by Константин Кириллов on 07.01.2022.
//

import SwiftUI

struct WordDescriptoinView: View {
    
    @State private var engName = ""
    @State private var rusName = ""
    
    @Binding var isPresented: Bool
    @ObservedObject var wordsList: WordList
    
    var initialEngName = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("new word", text: $engName)
                    .onAppear {
                        if initialEngName != "" {
                            engName = initialEngName
                        }
                    }
                TextField("перевод", text: $rusName)
            }
            .navigationTitle("add word")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        let newWord = Word(onEnglish: engName, onRussian: rusName)
                        self.wordsList.words.append(newWord)
                        
                        let encoder = JSONEncoder()

                        if let data = try? encoder.encode(wordsList.words) {
                            UserDefaults.standard.set(data, forKey: "words")
                        }
                        
                        self.isPresented.toggle()
                    }) {
                        Text("Save")
                    }
                    
                }
            }
        }
    }
}

struct WordDescriptoinView_Previews: PreviewProvider {
    static var previews: some View {
//        WordDescriptoinView(isPresented: .constant(true), wordsList: [Word(engName: "Home", rusName: "Дом")])
        ContentView()
    }
}
