//
//  AllModels.swift
//  Zalo-Feed-Exercise
//
//  Created by Bui Anh Lap on 30/05/2022.
//

import Foundation

struct ZAPhotoWrapper: Decodable {
    let photo: ZAPhoto
}

struct ZAPhoto: Decodable {
    let id: String
    let urls: ZAURL?
    let user: ZAUser?
    let likes: Int?
    let likedByUser: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, urls, user, likes
        case likedByUser = "liked_by_user"
    }
}

extension ZAPhoto {
    struct ZAURL: Decodable {
        let thumb: String?
    }
    
    struct ZAUser: Decodable {
        let id: String
        let name: String?
    }
}
