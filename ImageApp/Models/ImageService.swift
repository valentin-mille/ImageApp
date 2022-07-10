//
//  ImageService.swift
//  ImageApp
//
//  Created by Valentin Mille on 7/10/22.
//

import Foundation

struct ImageParameter {
    let key: String
    let searchText: String?
    let imageType: String
    let minWidth: Int
    let minHeight: Int

    init(searchText: String?) {
        key = Constants.API.key
        imageType = "photo"
        minWidth = 100
        minHeight = 100
        self.searchText = searchText
    }
}

enum ImageService {
    static func getImages(params: ImageParameter, completion: @escaping (Result<Images, APIServiceError>) -> Void) {
        guard var url = URLComponents(string: EndPoints.Images.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }

        url.queryItems = [
            URLQueryItem(name: "key", value: params.key),
            URLQueryItem(name: "q", value: params.searchText),
            URLQueryItem(name: "image_type", value: params.imageType),
            URLQueryItem(name: "min_width", value: String(params.minWidth)),
            URLQueryItem(name: "min_height", value: String(params.minHeight)),
        ]
        url.percentEncodedQuery = url.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        URLSession.shared.resumeDataTask(with: url.url!, withTypedResponse: completion)
    }
}
