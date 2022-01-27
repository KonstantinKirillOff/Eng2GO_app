//
//  ContentView.swift
//  Eng2GO_app
//
//  Created by Константин Кириллов on 08.01.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var addFormPresented = false
    @State private var showCancelButton = false
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
            VStack {
                HStack {
                    SearchBarView(searchWord: $searchText, showCancelButton: $showCancelButton)
                    if searchText != "" || showCancelButton {
                        Button {
                            withAnimation {
                                showCancelButton = false
                            }
                            searchText = ""
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .font(.title)
                        }
                    }
                    Button(action: { addFormPresented.toggle() }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                    .fullScreenCover(isPresented: $addFormPresented) {
                        WordDescriptoinView(isPresented: $addFormPresented, wordsList: wordsList, initialEngName: searchText)
                    }
                }
                
            List {
                ForEach(searchResult, id: \.onEnglish) { word in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(word.onEnglish)
                                .font(.title)
                            Text(word.onRussian)
                        }
                    }
                } .onDelete(perform: delete)
            }
            .navigationTitle("My words")
            .listStyle(.plain)
        }.padding(.horizontal, 15)
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
        self.wordsList.words.remove(atOffsets: offset)
        
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

