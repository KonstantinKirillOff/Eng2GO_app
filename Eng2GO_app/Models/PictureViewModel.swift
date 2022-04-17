//
//  pictureViewModel.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 03.04.2022.
//

import Foundation

class PictureViewModel: ObservableObject {
    @Published var urlImage = ""
    
    private static let key = "LUMG6YSLoGTass_HzRDzERd_dmrCMBSHpxqku6yl7P8"
    
    private func getUnSplashImages(for wordOnEnglish: String) {
        let query = wordOnEnglish.replacingOccurrences(of: " ", with: "%20")
        
        guard let url =
                URL(string: "https://api.unsplash.com/search/photos?query=\(query)&client_id=\(PictureViewModel.key)")
        else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let pictureData = try JSONDecoder().decode(ResponsePicture.self, from: data)
                if pictureData.results.count > 0 {
                    DispatchQueue.main.async { [self] in
                        urlImage = pictureData.results.randomElement()!.urls["thumb"]!
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func getImage(for wordOnEnglish: String, wordVM: WordViewModel) {
        if let indexWord = wordVM.words.firstIndex(where: { $0.onEnglish == wordOnEnglish }) {
            urlImage = wordVM.words[indexWord].imageURL
        } else {
            getUnSplashImages(for: wordOnEnglish)
        }
    }
    
    func changeImage(for wordOnEnglish: String) {
        getUnSplashImages(for: wordOnEnglish)
    }
}
