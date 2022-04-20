//
//  ContentView.swift
//  Eng2GO_app
//
//  Created by Константин Кириллов on 08.01.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var wordViewModel: WordViewModel
    @ObservedObject var pictureViewModel: PictureViewModel
    
    @State private var showCancelButton = false
    @State private var searchText = ""
    
    var searchResult: [Word] {
        if searchText.isEmpty {
            return wordViewModel.words
        } else {
            return wordViewModel.words.filter { $0.onEnglish.contains(searchText) }
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
                    
                    if searchResult.count == 0 {
                        NavigationLink(destination:WordDescriptoinView(
                            wordViewModel: wordViewModel,
                            initialUrl: "",
                            initialEngName: searchText,
                            initialRusName: "")
                                        .navigationBarBackButtonHidden(true)) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                    }
                }.padding(.horizontal)
                List {
                    ForEach(searchResult, id: \.onEnglish) { word in
                        NavigationLink(destination: WordDescriptoinView(
                                                    wordViewModel: wordViewModel,
                                                    initialUrl: word.imageURL,
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
                    .onDelete(perform: wordViewModel.deleteWord)
                }
                .listStyle(.plain)
                .navigationTitle("My words")
            }
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(wordViewModel: WordViewModel(), pictureViewModel: PictureViewModel())
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


