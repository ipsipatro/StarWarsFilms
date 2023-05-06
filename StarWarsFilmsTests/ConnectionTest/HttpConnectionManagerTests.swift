//
//  HttpConnectionManagerTests.swift
//  StarWarsFilmsTests
//
//  Created by Ipsi Patro on 06/05/2023.
//

import Foundation

import XCTest
@testable import StarWarsFilms

class HttpConnectionManagerTests: XCTestCase {
    
    var sut: HttpConnectionManager!
    var mockConnectionService: MockHttpConnectionService!
    var mockURLProvider: URLProvideable!
    
    override func setUp() {
        super.setUp()
        mockConnectionService = MockHttpConnectionService()
        mockURLProvider = Factory.urls
        sut = HttpConnectionManager(connectionService: mockConnectionService, urlProvider: mockURLProvider)
    }
    
    override func tearDown() {
        sut = nil
        mockConnectionService = nil
        mockURLProvider = nil
        super.tearDown()
    }
    
    func testRetrieveFilms_SuccessfulResponse() {
        // Create a mock film response
        let film = Film()
        film.title = "Film 1"
        let filmResponse = FilmResponse(results: [film])
        let jsonData = try! JSONEncoder().encode(filmResponse)
        
        // Configure the mock connection service to return a successful response with the mock film data
        mockConnectionService.result = .success(jsonData)
        
        // Define the expectation for the completion block
        let expectation = XCTestExpectation(description: "Fetch Films Completion")
        
        // Call the fetchFilms method
        sut.retrieveFilms { result in
            switch result {
            case .success(let films):
                // Assert that the fetched films match the mock film response
                XCTAssertEqual(films.count, 1)
                XCTAssertEqual(films[0].title, "Film 1")
            case .failure(let error):
                XCTFail("Fetch Films failed with error: \(error)")
            }
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRetrieveFilms_FailureResponse() {
        // Configure the mock connection service to return a failure response
        let error = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        mockConnectionService.result = .failure(error)
        
        
        // Define the expectation for the completion block
        let expectation = XCTestExpectation(description: "Fetch Films Completion")
        
        // Call the fetchFilms method
        sut.retrieveFilms { result in
            switch result {
            case .success(_):
                XCTFail("Fetch Films should fail with an error")
            case .failure(let error):
                // Assert that the error matches the expected error
                XCTAssertEqual((error as NSError).domain, "TestErrorDomain")
                XCTAssertEqual((error as NSError).code, 123)
            }
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRetrieveCharactersForFilm_SuccessfulResponse() {
        // Create a mock film response
        let character = Character(name: "Luke Skywalker")
        let jsonData = try! JSONEncoder().encode(character)
        
        // Configure the mock connection service to return a successful response with the mock film data
        mockConnectionService.result = .success(jsonData)
        
        // Define the expectation for the completion block
        let expectation = XCTestExpectation(description: "GetCharacters Completion")
        
        // Call the getCharacters method
        sut.retrieveCharactersForFilm(from: [""]) { result in
            switch result {
            case .success(let characters):
                // Assert that the fetched films match the mock film response
                XCTAssertEqual(characters.count, 1)
                XCTAssertEqual(characters[0].name, "Luke Skywalker")
            case .failure(let error):
                XCTFail("GetCharacters failed with error: \(error)")
            }
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRetrieveCharactersForFilm_FailureResponse() {
        // Configure the mock connection service to return a failure response
        let error = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        mockConnectionService.result = .failure(error)
        
        
        // Define the expectation for the completion block
        let expectation = XCTestExpectation(description: "Get Characters Completion")
        
        // Call the getCharacters method
        sut.retrieveCharactersForFilm(from: [""]) { result in
            switch result {
            case .success(_):
                XCTFail("Get Characters should fail with an error")
            case .failure(let error):
                // Assert that the error matches the expected error
                XCTAssertEqual((error as NSError).domain, "TestErrorDomain")
                XCTAssertEqual((error as NSError).code, 123)
            }
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockHttpConnectionService: HttpConnectionServiceable {
    var result: Result<Data?, Error> = .success(nil)
    
    func makeHttpRequest(url: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        switch result {
        case .success(let data):
            completion(.success(data))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
