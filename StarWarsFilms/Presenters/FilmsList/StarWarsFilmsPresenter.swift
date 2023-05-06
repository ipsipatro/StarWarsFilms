//
//  StarWarsFilmsPresenter.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

protocol StarWarsFilmsPresenterDelegate: AnyObject {
    func didTapFilm(_ film: Film)
}

final class StarWarsFilmsPresenter {
    // MARK: - Private variables
    private weak var delegate: StarWarsFilmsPresenterDelegate?
    private let connectionService: HttpConnectionCapable
    private let view: StarWarsFilmsView
    private let localStorageManager: LocalStorageManagable
    
    // MARK: - Instantiate
    init(delegate: StarWarsFilmsPresenterDelegate?, view: StarWarsFilmsView,
         connectionService: HttpConnectionCapable, localStorageManager: LocalStorageManagable) {
        self.delegate = delegate
        self.view = view
        self.connectionService = connectionService
        self.localStorageManager = localStorageManager
    }
    
    func viewLoaded() {
        retrieveFilms()
    }
    
    // MARK: - Private methods
    private func retrieveFilms() {
        view.startLoading()
        do {
            // Try to retrieve films from Realm
            let films = try localStorageManager.retrieveFilms()
            if !films.isEmpty {
                view.finishLoading()
                view.setFilms(films: films)
                return
            }
            
            // If films not found in Realm, make a network request
            self.connectionService.retrieveFilms { [weak self] result in
                self?.view.finishLoading()
                do {
                    switch result {
                    case .success(let films):
                        try self?.localStorageManager.saveFilms(films)
                        self?.view.setFilms(films: films)
                    case .failure(let error):
                        self?.view.showErrorAlert(withMessage: error.localizedDescription)
                    }
                } catch {
                    self?.view.showErrorAlert(withMessage: error.localizedDescription)
                }
            }
        } catch  {
            view.showErrorAlert(withMessage: error.localizedDescription)
        }
    }
    
    func didTapFilm(_ film: Film) {
        delegate?.didTapFilm(film)
    }
}


