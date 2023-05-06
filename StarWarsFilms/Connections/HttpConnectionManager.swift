//
//  HttpConnectionManager.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import Foundation

// MARK: - Errors
enum APIError: Error, Equatable {
    case emptyResponse
    case failedToDecode
    case unknown
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return NSLocalizedString(Constants.emptyResponseErrorMessage, comment: Constants.apiError)
        case .failedToDecode:
            return NSLocalizedString(Constants.failedToDecodeErrorMessage, comment: Constants.apiError)
        case .unknown:
            return NSLocalizedString(Constants.unknownErrorMessage, comment: Constants.apiError)
        }
    }
}

protocol HttpConnectionCapable {
    func retrieveFilms(completion: @escaping (Result<[Film], Error>) -> Void)
    func retrieveCharactersForFilm(from urls: [String], completion: @escaping (Result<[Character], Error>) -> Void)
}

final class HttpConnectionManager: HttpConnectionCapable {
    
    private let urlProvider: URLProvideable
    private let connectionService: HttpConnectionServiceable
    
    // MARK: - Instantiate
    init(connectionService: HttpConnectionServiceable = HttpConnectionService(), urlProvider: URLProvideable = Factory.urls) {
        self.connectionService = connectionService
        self.urlProvider = urlProvider
    }
    
    func retrieveFilms(completion: @escaping (Result<[Film], Error>) -> Void) {
        let urlString = self.urlProvider.getFilmsURL()
        
        connectionService.makeHttpRequest(url: urlString) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(APIError.emptyResponse))
                    return
                }
                
                do {
                    let filmResponse: FilmResponse
                    do {
                        let decoder = JSONDecoder()
                        filmResponse = try decoder.decode(FilmResponse.self, from: data)
                    } catch {
                        throw APIError.failedToDecode
                    }
                    completion(.success(filmResponse.results ?? []))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func retrieveCharactersForFilm(from urls: [String], completion: @escaping (Result<[Character], Error>) -> Void) {
        let group = DispatchGroup()
        var characters: [Character] = []
        var errors: [Error] = []
        
        for urlString in urls {
            group.enter()
            
            connectionService.makeHttpRequest(url: urlString) { result in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        completion(.failure(APIError.emptyResponse))
                        group.leave()
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let character = try decoder.decode(Character.self, from: data)
                        characters.append(character)
                    } catch {
                        errors.append(error)
                    }
                case .failure(let error):
                    errors.append(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if errors.isEmpty {
                completion(.success(characters))
            } else {
                completion(.failure(errors[0]))
            }
        }
    }
}
