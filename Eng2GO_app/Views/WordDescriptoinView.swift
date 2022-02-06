//
//  WordDescriptoinView.swift
//  English2Go
//
//  Created by Константин Кириллов on 07.01.2022.
//

import SwiftUI

struct WordDescriptoinView: View {
    @EnvironmentObject var wordData: WordViewModel
    
    @State private var engName = ""
    @State private var rusName = ""
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var initialEngName = ""
    var initialRusName = ""
    
    var body: some View {
        VStack {
            ZStack() {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.black)            }
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
                            if let indexWord = self.wordData.words.firstIndex(where: {
                                $0.onEnglish == engName
                            }) {
                                rusName = self.wordData.words[indexWord].onRussian
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
                                if let indexWord = self.wordData.words.firstIndex(where: {
                                    $0.onEnglish == engName
                                }) {
                                    self.wordData.words.remove(at: indexWord)
                                    
                                    let newWord = Word(onEnglish: engName, onRussian: rusName)
                                    self.wordData.words.insert(newWord, at: indexWord)
            
                                    let encoder = JSONEncoder()
                                    if let data = try? encoder.encode(wordData.words) {
                                        UserDefaults.standard.set(data, forKey: "words")
                                    }
                                } else {
                                    let newWord = Word(onEnglish: engName, onRussian: rusName)
                                    self.wordData.words.append(newWord)
                                    
                                    let encoder = JSONEncoder()
                                    
                                    if let data = try? encoder.encode(wordData.words) {
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
}

struct WordDescriptoinView_Previews: PreviewProvider {
    static var previews: some View {
        WordDescriptoinView()
    }
}
