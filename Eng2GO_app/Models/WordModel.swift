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
    var transcription = ""
}

struct WordGroup: Identifiable {
    var id = UUID()
    var name: String
    var wordList: [Word]
}



