//
//  SearchBarView.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 26.01.2022.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchWord: String
    @Binding var showCancelButton: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search...", text: $searchWord)
                    .onTapGesture {
                        withAnimation {
                            showCancelButton = true
                        }
                    }
            }
            .padding(5)
            .background(Color(.systemFill))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemFill), lineWidth: 1))
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchWord: .constant("Home"), showCancelButton: .constant(true))
    }
}
