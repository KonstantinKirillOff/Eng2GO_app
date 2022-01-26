//
//  Word.swift
//  Eng2GO_app
//
//  Created by Константин Кириллов on 08.01.2022.
//

import Foundation

struct Word: Codable {
    var isLearned = false
    var onEnglish: String
    var onRussian: String
}


class WordList: ObservableObject {
    @Published var words = [Word]()
    
    func searchWord(by engName: String) -> Word? {
        var findingWord: Word!
        for word in words {
            if word.onEnglish == engName.uppercased() {
                findingWord = word
            }
        }
        return findingWord
    }
}
