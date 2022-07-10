//
//  ImageModel.swift
//  ImageApp
//
//  Created by Valentin Mille on 7/10/22.
//

import Foundation

struct Image: Codable {
    let id: Int
    let pageURL: String
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let largeImageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case pageURL
        case previewURL
        case previewWidth
        case previewHeight
        case largeImageURL
    }
}

struct Images: Codable {
    let total: Int
    let totalHits: Int
    let hits: [Image]
}
