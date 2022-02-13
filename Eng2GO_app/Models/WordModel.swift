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
    var imageUrl = ""
}

struct WordsToGo {
    private (set) var wordsList: [Word]
    
    static func getWord() -> Word {
        return Word(
            isLearned: false,
            onEnglish: "House",
            onRussian: "Дом, жилище",
            transcription: "[home]",
            imageUrl: "https://unsplash.com/photos/7pCFUybP_P8")
    }
    
    init() {
        wordsList = getWordsList()
    }
    
    mutating func saveWord(
        with englishName:  String,
        and russianName: String,
        imageUrl: String = "",
        isLearned: Bool = false,
        transcript: String = "") {
        
        if let indexWord = wordsList.firstIndex(where: {
            $0.onEnglish == englishName
        }) {
            wordsList[indexWord].onRussian = russianName
            wordsList[indexWord].onEnglish = englishName
            wordsList[indexWord].imageUrl  = imageUrl
            wordsList[indexWord].isLearned = isLearned
            saveWordsList()
        } else {
            let newWord = Word(
                isLearned: isLearned,
                onEnglish: englishName,
                onRussian: russianName,
                transcription: transcript,
                imageUrl: imageUrl)
            wordsList.append(newWord)
            saveWordsList()
        }
    }
    
    func saveWordsList() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(wordsList) {
            UserDefaults.standard.set(data, forKey: "words")
        }
    }
    
    mutating func getWordsList() -> [Word] {
        if let wordsData = UserDefaults.standard.value(forKey: "words") {
            let decoder = JSONDecoder()
            
            if let words = try? decoder.decode([Word].self, from: wordsData as! Data) {
                return words
            } else {
                return [Word]()
            }
        }
    }
    
    
}



