//
//  WordView.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 11.04.2022.
//

import SwiftUI

struct WordView: View {
    @State private var engName = ""
    @State private var imageUrl = ""
    
    
    var body: some View {
        VStack {
            
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                        .clipped()
                        
                } placeholder: {
                    Image(systemName: "xmark.shield")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                        .clipped()
                }
                
                
                TextField("new word", text: $engName)
                    .textFieldStyle(.roundedBorder)
                    .border(.black)
                    .onSubmit {
                        getImagesUnSplash(for: engName)
                    }
                Button(action: { getImagesUnSplash(for: engName) } ) {
                    Text("Fetch image")
                }
            } else {
                // Fallback on earlier versions
            }
            
        }
        .padding()
        
    }
    
    func getImagesUnSplash(for word: String) {
        var photoArray = [Picture]()
        
        let key = "LUMG6YSLoGTass_HzRDzERd_dmrCMBSHpxqku6yl7P8"
        let query = word.replacingOccurrences(of: " ", with: "%20")
        
        guard let url = URL(string: "https://api.unsplash.com/search/photos?page=1&per_page=10&query=\(query)&client_id=\(key)")  else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let pictureData = try JSONDecoder().decode(ResponsePicture.self, from: data)
                for photo in pictureData.results {
                    DispatchQueue.main.async {
                        photoArray.append(photo)
                        imageUrl = photoArray.randomElement()!.urls["thumb"]!
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView()
    }
}
