//
//  PhotoNetworkService.swift
//  Zalo-Feed-Exercise
//
//  Created by Bui Anh Lap on 30/05/2022.
//

import Foundation

struct PhotoNetworkService {
    private let client: APIClient
    
    init(client: APIClient = .shared) {
        self.client = client
    }
    
    func fetchPhotos(ModelPage: ModelPage ,completion: @escaping (Result<[ZAPhoto], APIError>) -> Void) {
        client.request(method: .get, endpoint: .listPhotos(page: ModelPage.currentPage, perPage: ModelPage.perPage), objectType: [ZAPhoto].self, completion: completion)
    }
    
    func updateLike(id: String, isUnlike: Bool, completion: @escaping (Result<ZAPhoto, APIError>) -> Void) {
        if isUnlike {
            unlikePhoto(id: id, completion: completion)
        } else {
            likePhoto(id: id, completion: completion)
        }
    }
    
    private func likePhoto(id: String, completion: @escaping (Result<ZAPhoto, APIError>) -> Void) {
        client.request(method: .post, endpoint: .likePhoto(id: id), objectType: ZAPhotoWrapper.self) { result in
            completion(result.map { $0.photo })
        }
    }
    
    private func unlikePhoto(id: String, completion: @escaping (Result<ZAPhoto, APIError>) -> Void) {
        client.request(method: .delete, endpoint: .likePhoto(id: id), objectType: ZAPhotoWrapper.self) { result in
            completion(result.map { $0.photo })
        }
    }
}
