//
//  StorageManager.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 27.03.2022.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "words"
    
    private init() {}
    
    func saveInStorage(wordsList words: [Word]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(words) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func getWordsList() -> [Word] {
        if let wordsData = userDefaults.value(forKey: key) {
            let decoder = JSONDecoder()
            
            if let words = try? decoder.decode([Word].self, from: wordsData as! Data) {
                return words
            } else {
                var emptyWordList = [Word]()
                emptyWordList.append(getMockWord())
                
                return emptyWordList
            }
        } else {
            return [Word]()
        }
    }
    
    func getMockWord() -> Word {
        return Word(
            isLearned: false,
            onEnglish: "House",
            onRussian: "Дом, жилище",
            transcription: "[home]",
            imageUrl: "https://unsplash.com/photos/7pCFUybP_P8")
    }
    
}
