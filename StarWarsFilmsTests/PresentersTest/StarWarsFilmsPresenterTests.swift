//
//  StarWarsFilmsPresenterTests.swift
//  StarWarsFilmsTests
//
//  Created by Ipsi Patro on 06/05/2023.
//

import XCTest
@testable import StarWarsFilms

class StarWarsFilmsPresenterTests: XCTestCase {
    var presenter: StarWarsFilmsPresenter!
    var mockDelegate: MockFilmsCoordinator!
    var mockView: MockStarWarsFilmsView!
    var mockConnectionService: MockConnectionService!
    var mockLocalStorageManager: MockLocalStorageManager!
    var films = [Film]()
    
    override func setUp() {
        super.setUp()
        
        mockDelegate = MockFilmsCoordinator()
        mockView = MockStarWarsFilmsView()
        mockConnectionService = MockConnectionService()
        mockLocalStorageManager = MockLocalStorageManager()
        
        presenter = StarWarsFilmsPresenter(delegate: mockDelegate, view: mockView,
                                           connectionService: mockConnectionService,
                                           localStorageManager: mockLocalStorageManager)
        films = [Film(), Film(), Film()]
    }
    
    func testViewLoaded_FetchFilmsFromLocalStorageAndNetwork() {
        presenter.viewLoaded()
        
        XCTAssertTrue(mockView.startLoadingCalled)
        XCTAssertTrue(mockView.finishLoadingCalled)
        XCTAssertTrue(mockConnectionService.fetchFilmsCalled)
        XCTAssertTrue(mockLocalStorageManager.saveFilmsCalled)
        XCTAssertTrue(mockView.setFilmsCalled)
        XCTAssertFalse(mockView.showErrorAlertCalled)
    }
    
    func testOnReceiveOfFilms_SetAllFilmOnView() {
        mockConnectionService.mockFilms = films
        presenter.viewLoaded()
        XCTAssertTrue(mockView.startLoadingCalled)
        XCTAssertTrue(mockView.finishLoadingCalled)
        XCTAssertEqual(mockView.films?.count, films.count)
    }
    
    func testOnReceiveOfFilms_SaveThemToLocalStorage() {
        mockConnectionService.mockFilms = films
        presenter.viewLoaded()
        XCTAssertEqual(try mockLocalStorageManager.retrieveFilms().count, films.count)
    }
    
    func testOnTapOfFilm_CallDelegateDidTapFilm() {
        let film = Film()
        presenter.didTapFilm(film)
        XCTAssertTrue(mockDelegate.didTapFilmCalled)
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

class MockLocalStorageManager: LocalStorageManagable {
    var fetchFilmsCalled = false
    var saveFilmsCalled = false
    var films: [Film]?
    
    func retrieveFilms() throws -> [Film] {
        fetchFilmsCalled = true
        return films ?? []
    }
    
    func saveFilms(_ films: [Film]) throws {
        saveFilmsCalled = true
        self.films = films
    }
}

class MockStarWarsFilmsView: StarWarsFilmsView {
    var startLoadingCalled = false
    var finishLoadingCalled = false
    var setFilmsCalled = false
    var showErrorAlertCalled = false
    var films: [Film]?
    var errorMessage: String?
    
    func startLoading() {
        startLoadingCalled = true
    }
    
    func finishLoading() {
        finishLoadingCalled = true
    }
    
    func setFilms(films: [Film]) {
        setFilmsCalled = true
        self.films = films
    }
    
    func showErrorAlert(withMessage message: String) {
        showErrorAlertCalled = true
        errorMessage = message
    }
}

class MockFilmsCoordinator: StarWarsFilmsPresenterDelegate {
    var didTapFilmCalled = false
    func didTapFilm(_ film: StarWarsFilms.Film) {
        didTapFilmCalled = true
    }
}

