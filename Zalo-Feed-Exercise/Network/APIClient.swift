//
//  APIClient.swift
//  Zalo-Feed-Exercise
//
//  Created by Bui Anh Lap on 30/05/2022.
//

import Foundation

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum APIError : Error {
    case networkError(Error)
    case jsonParsingError(Error)
    case invalidData
    case invalidUrl
}
class APIClient {
    static let shared = APIClient()
    
    func request<T: Decodable>(method: HTTPMethod, endpoint: APIEndpoint, objectType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let dataURL = URL(string: endpoint.urlString) else {
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.httpMethod = method.rawValue
        request.setValue(Constants.authToken, forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(APIError.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch let error {
                completion(.failure(APIError.jsonParsingError(error as! DecodingError)))
            }
        })
        
        task.resume()
    }
}
