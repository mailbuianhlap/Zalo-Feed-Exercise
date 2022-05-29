//
//  APIEndpoint.swift
//  Zalo-Feed-Exercise
//
//  Created by Bui Anh Lap on 30/05/2022.
//

import Foundation

enum APIEndpoint {
    case listPhotos(page: Int, perPage: Int)
    case likePhoto(id: String)
    
    var path: String {
        switch self {
            case .listPhotos(let page, let perPage):
                return "/photos?page=\(page)&per_page=\(perPage)"
            case .likePhoto(let id):
                return "/photos/\(id)/like"
        }
    }
    
    var urlString: String {
        return Constants.baseUrl + path
    }
}
