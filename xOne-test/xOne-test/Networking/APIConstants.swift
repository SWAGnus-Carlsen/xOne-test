//
//  APIConstants.swift
//  xOne-test
//
//  Created by Vitaliy Halai on 5.09.23.
//

import Foundation

struct APIConstants {
    static let breedsUrl = "https://api.thecatapi.com/v1/breeds?limit=10"
    
    static func imageURL(_ id: String?) -> String {
        guard let id else { return "" }
        return "https://api.thecatapi.com/v1/images/\(id)"
    }
    static let nameOfHeader = "x-api-key"
    
    static let authToken = "live_ZGsMt83p2ahrSGQnxZGr2c2jNpFMUVdiWqUq9fypO9p6NNKkGUUX3OyW8anKkLE6"
}

