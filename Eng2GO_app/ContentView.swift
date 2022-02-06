//
//  ContentView.swift
//  Eng2GO_app
//
//  Created by Константин Кириллов on 08.01.2022.
//

import SwiftUI

protocol UpdateList {
    func updateList(eng: String, rus: String)
}

struct ContentView: View {
    @EnvironmentObject var wordData: WordViewModel
    
    @State private var showCancelButton = false
    @State private var searchText = ""
    
    @StateObject private var wordsList = WordViewModel()
    
    var searchResult: [Word] {
        if searchText.isEmpty {
            return wordsList.words
        } else {
            return wordsList.words.filter { $0.onEnglish.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBarView(searchWord: $searchText, showCancelButton: $showCancelButton)
                    if searchText != "" || showCancelButton {
                        Button {
                            withAnimation {
                                showCancelButton = false
                            }
                            searchText = ""
                            hideKeyboard()
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .font(.title)
                        }
                    }
                    NavigationLink(destination:WordDescriptoinView(
                                               initialEngName: searchText,
                                               initialRusName: "")
                                                    .navigationBarBackButtonHidden(true)) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                    }
                }.padding(.horizontal)
                List {
                    ForEach(searchResult, id: \.onEnglish) { word in
                        NavigationLink(destination: WordDescriptoinView(
                                                    initialEngName: word.onEnglish,
                                                    initialRusName: word.onRussian)
                                                        .navigationBarBackButtonHidden(true)) {
                            VStack(alignment: .leading) {
                                Text(word.onEnglish)
                                    .font(.title)
                                Text(word.onRussian)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                .navigationTitle("My words")
            }
            .onAppear {
                update()
            }
            
        }
    }
    
    func delete(at offset: IndexSet) {
        self.wordsList.words.remove(atOffsets: offset)
        
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(wordsList.words) {
            UserDefaults.standard.set(data, forKey: "words")
        }
    }
    
    func update() {
        if let wordsData = UserDefaults.standard.value(forKey: "words") {
            let decoder = JSONDecoder()
            
            if let words = try? decoder.decode([Word].self, from: wordsData as! Data) {
                self.wordsList.words = words
            }
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


