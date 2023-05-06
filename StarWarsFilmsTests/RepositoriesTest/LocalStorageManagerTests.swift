//
//  LocalStorageManagerTests.swift
//  StarWarsFilmsTests
//
//  Created by Ipsi Patro on 06/05/2023.
//

import XCTest
import RealmSwift
@testable import StarWarsFilms

class LocalStorageManagerTests: XCTestCase {
    
    var realm: Realm!
    var localStorageManager: LocalStorageManager!
    var films: [Film]!
    
    override func setUp() {
        super.setUp()
        
        // Create an in-memory Realm for testing
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        
        // Initialize the LocalStorageManager with the test Realm
        localStorageManager = LocalStorageManager(realm)
        
        let film1 = Film()
        film1.title = "Film 1"
        let film2 = Film()
        film2.title = "Film 2"
        let film3 = Film()
        film3.title = "Film 3"
        films = [film1, film2, film3]
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Clean up the Realm after each test
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func testSaveAndFetchFilms() {
        // Save the films
        XCTAssertNoThrow(try localStorageManager.saveFilms(films))
        
        // Fetch the films from Realm
        let fetchedFilms = try! localStorageManager.retrieveFilms()
        
        // Assert that the fetched films match the saved films
        XCTAssertEqual(fetchedFilms.count, films.count)
        XCTAssertEqual(fetchedFilms[0].title, "Film 1")
        XCTAssertEqual(fetchedFilms[1].title, "Film 2")
        XCTAssertEqual(fetchedFilms[2].title, "Film 3")
    }
    
    
    func testSaveFilmsWithoutRealm() {
        localStorageManager = LocalStorageManager(nil)
        // Attempt to save films without setting a realm
        XCTAssertThrowsError(try localStorageManager.saveFilms([])) { error in
            XCTAssertEqual((error as NSError).domain, "LocalStorageManager")
            XCTAssertEqual((error as NSError).code, 0)
            XCTAssertEqual((error as NSError).localizedDescription, "Realm not set")
        }
    }
    
    func testFetchFilmsWithoutRealm() {
        localStorageManager = LocalStorageManager(nil)
        // Attempt to fetch films without setting a realm
        XCTAssertThrowsError(try localStorageManager.retrieveFilms()) { error in
            XCTAssertEqual((error as NSError).domain, "LocalStorageManager")
            XCTAssertEqual((error as NSError).code, 0)
            XCTAssertEqual((error as NSError).localizedDescription, "Realm not set")
        }
    }
}
