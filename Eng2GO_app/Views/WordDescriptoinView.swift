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
    @State private var showAlert = false
    
    @ObservedObject var wordsList: WordList
    @Environment(\.presentationMode) var presentationMode
    
    var initialEngName = ""
    var initialRusName = ""
    
    var body: some View {
        Form {
            TextField("new word", text: $engName)
                .onAppear {
                    if initialEngName != "" {
                        engName = initialEngName
                    }
                    if initialRusName != "" {
                        rusName = initialRusName
                    }
                }
            TextField("перевод", text: $rusName)
                .onAppear {
                    if rusName == "" {
                        if let indexWord = self.wordsList.words.firstIndex(where: {
                            $0.onEnglish == engName
                        }) {
                            rusName = self.wordsList.words[indexWord].onRussian
                        }
                    }
                }
        }
        .navigationTitle("add word")
        .toolbar {
            ToolbarItem {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Cancel")
                    }
                    Button(action: {
                        if engName != "" && rusName != "" {
                            if let indexWord = self.wordsList.words.firstIndex(where: {
                                $0.onEnglish == engName
                            }) {
                                self.wordsList.words.remove(at: indexWord)
                                
                                let newWord = Word(onEnglish: engName, onRussian: rusName)
                                self.wordsList.words.insert(newWord, at: indexWord)
        
                                let encoder = JSONEncoder()
                                if let data = try? encoder.encode(wordsList.words) {
                                    UserDefaults.standard.set(data, forKey: "words")
                                }
                            } else {
                                let newWord = Word(onEnglish: engName, onRussian: rusName)
                                self.wordsList.words.append(newWord)
                                
                                let encoder = JSONEncoder()
                                
                                if let data = try? encoder.encode(wordsList.words) {
                                    UserDefaults.standard.set(data, forKey: "words")
                                }
                            }
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            self.showAlert = true
                        }
                    }) {
                        Text("Save")
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("Ошибка сохранения"),
                              message: Text("Поля слова и перевода должны быть заполнены"),
                              dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}

struct WordDescriptoinView_Previews: PreviewProvider {
    static var previews: some View {
        WordDescriptoinView(wordsList: WordList())
    }
}
