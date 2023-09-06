//
//  CatModel.swift
//  xOne-test
//
//  Created by Vitaliy Halai on 5.09.23.
//

import Foundation

// MARK: - Cat
struct CatBreed: Codable {
    let name: String
    let wikipedia_url: String
    let reference_image_id: String
}

struct CatImage: Codable {
    let url: String
}




