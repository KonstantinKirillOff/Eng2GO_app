//
//  pictureViewModel.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 03.04.2022.
//

import Foundation

class PictureViewModel: ObservableObject {
    private let key = "LUMG6YSLoGTass_HzRDzERd_dmrCMBSHpxqku6yl7P8"
    @Published var photoArray: [Picture] = []
    
    func getImagesUnSplash(for word: String) {
        let query = word.replacingOccurrences(of: " ", with: "%20")
        let url = "https://api.unsplash.com/search/photos?page=1&query=\(query)&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _, error) in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode([Picture].self, from: data)
                for photo in json {
                    DispatchQueue.main.async {
                        self.photoArray.append(photo)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func changeImage() {
        
    }
}
