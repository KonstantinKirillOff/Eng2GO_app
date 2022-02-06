//
//  WordViewModel.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 06.02.2022.
//

import SwiftUI

class WordViewModel: ObservableObject {
    @Published var words = [Word]()
   
    @Published var groups: [WordGroup] = [
        WordGroup(name: "Group1", wordList: [
            Word(isLearned: false, onEnglish: "Kat", onRussian: "Кошечка"),
            Word(isLearned: false, onEnglish: "Kat2", onRussian: "Кошечка2")
        ]),
    
        WordGroup(name: "Group2", wordList: [
            Word(isLearned: false, onEnglish: "Dog", onRussian: "Собачка"),
            Word(isLearned: false, onEnglish: "Home", onRussian: "Домик")
        ])
    ]
    
    @Published var currentWord: String = ""
    @Published var showWord: Bool = false
    
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
