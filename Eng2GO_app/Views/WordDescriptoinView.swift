//
//  WordDescriptoinView.swift
//  English2Go
//
//  Created by Константин Кириллов on 07.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct WordDescriptoinView: View {
    let wordViewModel: WordViewModel
    @ObservedObject var pictureViewModel = PictureViewModel()
    
    @State private var urlImage = ""
    @State private var engName = ""
    @State private var rusName = ""
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var initialImage = ""
    var initialEngName = ""
    var initialRusName = ""
    
    var body: some View {
        VStack {
            //ZStack() {
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: urlImage)) { image in
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                } placeholder: {
                    Image(systemName: "xmark.shield")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.black)
                }
            } else {
                // Fallback on earlier versions
            }
                
//                WebImage(url: URL(string: urlImage))
//                    .resizable()
//                    .frame(width: 200, height: 200)
//                    .onAppear {
//                        if initialImage != "" {
//                            urlImage = initialImage
//                        }
//                    }
            Form {
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
                            //getImagesUnSplash(for: engName)
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
                                    wordViewModel.saveWord(with: engName, and: rusName)
                                } else {
                                    wordViewModel.saveWord(with: engName, and: rusName)
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
        WordDescriptoinView(wordViewModel: WordViewModel())
    }
}
