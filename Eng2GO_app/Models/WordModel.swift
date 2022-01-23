//
//  Word.swift
//  Eng2GO_app
//
//  Created by Константин Кириллов on 08.01.2022.
//

import Foundation

struct Word: Identifiable, Codable {
    let id = UUID()
    var isLearned = false
    
    var onEnglish: String
    var onRussian: String
}

class WordList: ObservableObject {
    @Published var words = [Word]()
}
