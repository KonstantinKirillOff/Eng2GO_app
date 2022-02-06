//
//  Eng2GO_appApp.swift
//  Eng2GO_app
//
//  Created by Константин Кириллов on 08.01.2022.
//

import SwiftUI

@main
struct Eng2GO_appApp: App {
    @StateObject var wordData = WordViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(wordData)
        }
    }
}
