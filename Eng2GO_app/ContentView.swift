//
//  ContentView.swift
//  Eng2GO_app
//
//  Created by Константин Кириллов on 08.01.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var addFormPresented = false
    @State private var searchText = ""
    @StateObject private var wordsList = WordList()
    
    var searchResult: [Word] {
        if searchText.isEmpty {
            return wordsList.words
        } else {
            return wordsList.words.filter { $0.onEnglish.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List {
                    ForEach(searchResult) { word in
                        HStack {
                            if #available(iOS 15.0, *) {
                                VStack(alignment: .leading) {
                                    Text(word.onEnglish)
                                        .font(.title)
                                    Text(word.onRussian)
                                }
                                .onSubmit {
                                    
                                }
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    } .onDelete(perform: delete)
                }
                .searchable(text: $searchText)
                .navigationTitle("My words")
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem {
                        Button(action: { addFormPresented.toggle() }) {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $addFormPresented) {
                            WordDescriptoinView(isPresented: $addFormPresented, wordsList: wordsList)
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .onAppear {
            if let wordsData = UserDefaults.standard.value(forKey: "words") {
                let decoder = JSONDecoder()
                
                if let words = try? decoder.decode([Word].self, from: wordsData as! Data) {
                    self.wordsList.words = words
                }
            }
        }
    }
    
    
    func delete(at offset: IndexSet) {
        wordsList.words.remove(atOffsets: offset)
        
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(wordsList.words) {
            UserDefaults.standard.set(data, forKey: "words")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
