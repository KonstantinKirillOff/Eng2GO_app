//
//  WordGroupListView.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 06.02.2022.
//

import SwiftUI

struct WordGroupListView: View {
    @State private var groups = [
        WordGroup(name: "Group1", wordList: [
            Word(isLearned: false, onEnglish: "Kat", onRussian: "Кошечка"),
            Word(isLearned: false, onEnglish: "Kat2", onRussian: "Кошечка2")])]
    
    var body: some View {
        NavigationView {
            List(groups) { group in
                NavigationLink(destination: EditWordGroupView(group: $groups[groups.firstIndex(where: { $0.id == group.id })!])) {
                    Text("\(group.name)")
                }
                
            }
        }
    }
}

struct WordGroupListView_Previews: PreviewProvider {
    static var previews: some View {
        WordGroupListView()
    }
}
