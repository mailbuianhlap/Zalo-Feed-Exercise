//
//  ImageHelper.swift
//  Zalo-Feed-Exercise
//
//  Created by Bui Anh Lap on 30/05/2022.
//

import Foundation
import UIKit


class ImageHelper {
    static func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
}
