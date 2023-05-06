//
//  HttpConnectionService.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import Alamofire

protocol HttpConnectionServiceable {
    func makeHttpRequest(url: String, completion: @escaping (Result<Data?, Error>) -> Void)
}

// This class contains methods to send actual API requests
final class HttpConnectionService: HttpConnectionServiceable {
    
    func makeHttpRequest(url: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        guard let requestURL = URL(string: url) else {
            let error = NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        AF.request(requestURL).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
