//
//  MockConnectionService.swift
//  StarWarsFilmsTests
//
//  Created by Ipsi Patro on 06/05/2023.
//

import Foundation
@testable import StarWarsFilms

class MockConnectionService: HttpConnectionCapable {
    var mockFilms: [Film] = []
    var mockCharacters: [Character] = []
    var mockError: APIError?
    var fetchFilmsCalled = false
    var getCharactersCalled = false
    
    func retrieveFilms(completion: @escaping (Result<[Film], Error>) -> Void) {
        fetchFilmsCalled = true
        
        if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.success(mockFilms))
        }
    }
    
    func retrieveCharactersForFilm(from urls: [String], completion: @escaping (Result<[StarWarsFilms.Character], Error>) -> Void) {
        getCharactersCalled = true
        if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.success(mockCharacters))
        }
    }
    
}
