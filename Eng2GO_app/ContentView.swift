//
//  ContentView.swift
//  Eng2GO_app
//
//  Created by Константин Кириллов on 08.01.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var addFormPresented = false
    @State private var words = [Word]()
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach($words) { $word in
                    HStack {
                        VStack(alignment: .leading) {
                            TextField("word", text: $word.onEnglish)
                                .font(.title)
                            TextField("перевод", text: $word.onRussian)
                        }
                        Spacer()
                        if #available(iOS 15.0, *) {
                            Toggle("Learned", isOn: $word.isLearned) .toggleStyle(.button)
                        } else {
                            Toggle("Learned", isOn: $word.isLearned)
                                .toggleStyle(.switch)
                        }
                    }
                }.onDelete(perform: delete)
            }
            .navigationTitle("My words")
            .listStyle(.plain)
            .toolbar {
                ToolbarItem {
                    Button(action: { addFormPresented.toggle() }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $addFormPresented) {
                        WordDescriptoinView(isPresented: $addFormPresented, wordsList: $words)
                    }
                }
            }
        }
        .onAppear {
            if let wordsData = UserDefaults.standard.value(forKey: "words") {
                let decoder = JSONDecoder()
                
                if let words = try? decoder.decode([Word].self, from: wordsData as! Data) {
                    self.words = words
                }
            }
        }
    }
    
    func delete(at offset: IndexSet) {
        words.remove(atOffsets: offset)
        
        let encoder = JSONEncoder()

        if let data = try? encoder.encode(words) {
            UserDefaults.standard.set(data, forKey: "words")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
