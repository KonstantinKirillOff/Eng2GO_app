//
//  NetworkManager.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 13.02.2022.
//

import Foundation

enum Errors: Error {
    case invalidURL
    case noData
}


class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImageData(from url: String) throws -> Data {
        guard let imageUrl = URL(string: url) else{ throw Errors.invalidURL }
        guard let imageData = try? Data(contentsOf: imageUrl) else { throw Errors.noData }
        return imageData
    }
    
    
}
