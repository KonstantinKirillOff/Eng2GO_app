//
//  WordDescriptoinView.swift
//  English2Go
//
//  Created by Константин Кириллов on 07.01.2022.
//

import SwiftUI

struct WordDescriptoinView: View {
    var wordViewModel: WordViewModel
    
    @State private var urlImage: String
    @State private var engName: String
    @State private var rusName: String
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init(wordViewModel: WordViewModel, initialUrl: String, initialEngName: String, initialRusName: String) {
        _engName = State(initialValue: initialEngName)
        _rusName = State(initialValue: initialRusName)
        _urlImage = State(initialValue: initialUrl)
        self.wordViewModel = wordViewModel
    }
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                if #available(iOS 15.0, *) {
                    AsyncImage(
                        url: URL(string: urlImage),
                        transaction: Transaction(animation: .easeInOut)
                    ) { phase in
                        switch phase {
                        case .empty: ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .transition(.scale(scale: 0.1, anchor: .center))
                        case .failure:
                            Image(systemName: "magnifyingglass")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                } else {}
                Spacer()
            }
            
            if #available(iOS 15.0, *) {
                TextField("add word", text: $engName)
                    .onAppear {
                        if urlImage == "" {
                            getUnSplashImage(for: engName)
                        }
                    }
                    .onSubmit {
                        getUnSplashImage(for: engName)
                    }
            } else {}
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
            Button(action: {  getUnSplashImage(for: engName) } ) {
                HStack {
                    Spacer()
                    Text("Change image")
                    Spacer()
                }
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("word description")
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
                                wordViewModel.saveWord(with: engName, and: rusName, imageUrl: urlImage)
                            } else {
                                wordViewModel.saveWord(with: engName, and: rusName, imageUrl: urlImage)
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
    
    private func getUnSplashImage(for wordOnEnglish: String) {
        
        let key = "LUMG6YSLoGTass_HzRDzERd_dmrCMBSHpxqku6yl7P8"
        let query = wordOnEnglish.replacingOccurrences(of: " ", with: "%20")
        
        guard let url =
                URL(string: "https://api.unsplash.com/search/photos?query=\(query)&client_id=\(key)")
        else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let pictureData = try JSONDecoder().decode(ResponsePicture.self, from: data)
                if pictureData.results.count > 0 {
                    DispatchQueue.main.async { [self] in
                        urlImage =  pictureData.results.randomElement()!.urls["thumb"]!
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct WordDescriptoinView_Previews: PreviewProvider {
    static var previews: some View {
        WordDescriptoinView(wordViewModel: WordViewModel(), initialUrl: "", initialEngName: "Kat", initialRusName: "Кошечка")
    }
}

