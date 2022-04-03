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
    var imageId = ""
}

struct Picture: Identifiable, Codable {
    var id: String
    var alt_description: String
    var urls: [String : String]
}

struct WordsToGo {
    private (set) var wordsList: [Word]
    private let storageManager = StorageManager.shared
    
    init() {
        wordsList = storageManager.getWordsList()
    }
    
    private func searchWord(by engName: String) -> Word? {
        var findingWord: Word!
        for word in wordsList {
            if word.onEnglish == engName.uppercased() {
                findingWord = word
            }
        }
        return findingWord
    }
    
    mutating func saveWord(
        with englishName:  String,
        and russianName: String,
        imageId: String = "",
        isLearned: Bool = false,
        transcript: String = "") {
            
            if let indexWord = wordsList.firstIndex(where: {
                $0.onEnglish == englishName
            }) {
                wordsList[indexWord].onRussian = russianName
                wordsList[indexWord].onEnglish = englishName
                wordsList[indexWord].imageId  = imageId
                wordsList[indexWord].isLearned = isLearned
            } else {
                let newWord = Word(
                    isLearned: isLearned,
                    onEnglish: englishName,
                    onRussian: russianName,
                    transcription: transcript,
                    imageId: imageId)
                wordsList.append(newWord)
            }
            storageManager.saveInStorage(wordsList: wordsList)
    }
    
    mutating func deleteWord(at offset: IndexSet) {
        wordsList.remove(atOffsets: offset)
        storageManager.saveInStorage(wordsList: wordsList)
    }
}



