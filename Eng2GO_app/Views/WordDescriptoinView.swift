//
//  WordDescriptoinView.swift
//  English2Go
//
//  Created by Константин Кириллов on 07.01.2022.
//

import SwiftUI

struct WordDescriptoinView: View {
    let wordViewModel: WordViewModel
    let pictureViewModel: PictureViewModel
    
    @State private var engName = ""
    @State private var rusName = ""
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var initialEngName = ""
    var initialRusName = ""
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: pictureViewModel.urlImage)) { image in
                        image
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                    } placeholder: {
                        Image(systemName: "xmark.shield")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.black)
                    }.padding()
                } else {
                    // Fallback on earlier versions
                }
                Spacer()
            }
            
            if #available(iOS 15.0, *) {
                TextField("new word", text: $engName)
                    .onAppear {
                        if initialEngName != "" {
                            engName = initialEngName
                        }
                        if initialRusName != "" {
                            rusName = initialRusName
                        }
                    }
                    .onSubmit {
                        pictureViewModel.changeImage(for: engName)
                    }
            } else {
                // Fallback on earlier versions
            }
            TextField("перевод", text: $rusName)
                .onAppear {
                    if rusName == "" {
                        if let indexWord = self.wordViewModel.words.firstIndex(where: {
                            $0.onEnglish == engName
                        }) {
                            rusName = self.wordViewModel.words[indexWord].onRussian
                        }
                    }
                }
            Button(action: {  pictureViewModel.changeImage(for: engName) } ) {
                Text("Change image")
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
                            if let indexWord = self.wordViewModel.words.firstIndex(where: {
                                $0.onEnglish == engName
                            }) {
                                let IndSet = IndexSet(integer: indexWord)
                                wordViewModel.deleteWord(at: IndSet)
                                wordViewModel.saveWord(with: engName, and: rusName, imageUrl: pictureViewModel.urlImage)
                            } else {
                                wordViewModel.saveWord(with: engName, and: rusName, imageUrl: pictureViewModel.urlImage)
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
        WordDescriptoinView(wordViewModel: WordViewModel(), pictureViewModel: PictureViewModel())
    }
}
