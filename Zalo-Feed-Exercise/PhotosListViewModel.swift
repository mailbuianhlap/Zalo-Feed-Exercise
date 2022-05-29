//
//  PhotosListViewModel.swift
//  Zalo-Feed-Exercise
//
//  Created by Bui Anh Lap on 30/05/2022.
//

import Foundation
class PhotosListViewModel {
    let networkService = PhotoNetworkService()
    var photos: [ZAPhoto] = []
    let modelPage = ModelPage()
    var isLoadMore = false
    
    func fetchPhotos(completion: (([ZAPhoto]) -> Void)? = nil) {
        networkService.fetchPhotos(ModelPage: modelPage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let photos):
                        self?.photos.append(contentsOf: photos)
                    case .failure:
                        break
                }
                completion?(self?.photos ?? [])
            }
        }
    }
    
    func photo(at index: Int) -> ZAPhoto? {
        guard photos.indices.contains(index) else { return nil }
        return photos[index]
    }
    
    func likeOrUnlikePhoto(at index: Int, completion: (() -> Void)? = nil) {
        guard let photo = photo(at: index) else {
            completion?()
            return
        }
        
        networkService.updateLike(id: photo.id, isUnlike: photo.likedByUser ?? false) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let photo):
                        self?.photos[index] = photo
                        completion?()
                    case .failure:
                        completion?()
                }
            }
        }
    }
    
    func loadMore(completion: @escaping (() -> Void)) {
        guard !isLoadMore else { return }
        isLoadMore = true
        modelPage.loadMore()
        fetchPhotos { [weak self] _ in
            self?.isLoadMore = false
            completion()
        }
    }
    
}
