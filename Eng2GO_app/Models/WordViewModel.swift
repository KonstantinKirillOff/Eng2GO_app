//
//  WordViewModel.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 06.02.2022.
//

import SwiftUI

class WordViewModel: ObservableObject {
    @Published private var modelWords = WordsToGo()
    
    var words: [Word] {
        modelWords.wordsList
    }
    
    func saveWord(with englishName:  String, and russianName: String,
                  imageUrl: String, isLearned: Bool = false, transcript: String = "") {
        modelWords.saveWord(with: englishName, and: russianName, imageURL: imageUrl)
    }
    
    func deleteWord(at offset: IndexSet) {
        modelWords.deleteWord(at: offset)
    }
    
    
}
