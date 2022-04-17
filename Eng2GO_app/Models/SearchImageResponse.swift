//
//  SearchImageResponse.swift
//  Eng2GO_app
//
//  Created by Konstantin Kirillov on 17.04.2022.
//

import Foundation

struct ResponsePicture: Codable {
    var results: [Picture]
}

struct Picture: Identifiable, Codable {
    var id: String
    var description: String?
    var urls: [String : String]
}

#if DEBUG
extension Picture {
    
    static var exampler: Picture {
        Picture(id: "eOLpJytrbsQ",
                description: "A man drinking a coffee.",
                urls: ["thumb": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=8aae34cf35df31a592f0bef16e6342ef"])
    }
}
#endif
