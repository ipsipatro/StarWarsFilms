//
//  StarWarsFilmDetailsPresenterTests.swift
//  StarWarsFilmsTests
//
//  Created by Ipsi Patro on 06/05/2023.
//


import XCTest
@testable import StarWarsFilms

class StarWarsFilmDetailsPresenterTests: XCTestCase {
    var presenter: StarWarsFilmDetailsPresenter!
    var mockView: MockStarWarsFilmDetailsView!
    var mockConnectionService: MockConnectionService!
    var film = Film()
    
    override func setUp() {
        super.setUp()
        mockView = MockStarWarsFilmDetailsView()
        mockConnectionService = MockConnectionService()
        
        presenter = StarWarsFilmDetailsPresenter(film: film, view: mockView, connectionService: mockConnectionService)
    }
    
    func testViewLoaded_CallgetCharacters() {
        presenter.viewLoaded()
        
        XCTAssertTrue(mockView.startLoadingCalled)
        XCTAssertTrue(mockView.finishLoadingCalled)
        XCTAssertTrue(mockConnectionService.getCharactersCalled)
        XCTAssertTrue(mockView.setCharactersCalled)
        XCTAssertFalse(mockView.showErrorAlertCalled)
    }
    
    func testOnAPIError_CallShowErrorAlert() {
        mockConnectionService.mockError = APIError.failedToDecode
        presenter.viewLoaded()
        XCTAssertTrue(mockView.showErrorAlertCalled)
        XCTAssertEqual(mockView.errorMessage, Constants.failedToDecodeErrorMessage)
    }
    
    func testOnAPIError_ShowErrorAlertWithRightErrorMessage() {
        mockConnectionService.mockError = APIError.emptyResponse
        presenter.viewLoaded()
        XCTAssertTrue(mockView.showErrorAlertCalled)
        XCTAssertEqual(mockView.errorMessage, Constants.emptyResponseErrorMessage)
    }
}

class MockStarWarsFilmDetailsView: StarWarsFilmDetailsView {

    var startLoadingCalled = false
    var finishLoadingCalled = false
    var setCharactersCalled = false
    var showErrorAlertCalled = false
    var characters: [Character]?
    var errorMessage: String?
    
    func startLoading() {
        startLoadingCalled = true
    }
    
    func finishLoading() {
        finishLoadingCalled = true
    }
    
    func setCharacters(characters: [Character]) {
        setCharactersCalled = true
        self.characters = characters
    }
    
    
    func showErrorAlert(withMessage message: String) {
        showErrorAlertCalled = true
        errorMessage = message
    }
}

