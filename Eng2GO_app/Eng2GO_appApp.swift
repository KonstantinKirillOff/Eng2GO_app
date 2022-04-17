//
//  Eng2GO_appApp.swift
//  Eng2GO_app
//
//  Created by Константин Кириллов on 08.01.2022.
//

import SwiftUI

@main
struct Eng2GO_appApp: App {
    let wordsApp = WordViewModel()
    let pictureVM = PictureViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(wordViewModel: wordsApp, pictureViewModel: pictureVM)
        }
    }
}
