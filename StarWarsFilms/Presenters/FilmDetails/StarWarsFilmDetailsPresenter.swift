//
//  StarWarsFilmDetailsPresenter.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//
import Foundation

final class StarWarsFilmDetailsPresenter {
    // MARK: - Private variables
    private let connectionService: HttpConnectionCapable
    private let view: StarWarsFilmDetailsView
    private let film: Film
    
    // MARK: - Instantiate
    init(film: Film, view: StarWarsFilmDetailsView,
         connectionService: HttpConnectionCapable) {
        self.film = film
        self.view = view
        self.connectionService = connectionService
    }
    
    func viewLoaded() {
        retrieveCharactersForFilm()
    }
    
    // MARK: - Private methods
    private func retrieveCharactersForFilm() {
        // Due to time constraints I couldn't persist characters but good to have that feature
        // TODO: Persist characters for offline support
        view.startLoading()
        self.connectionService.retrieveCharactersForFilm(from: Array(film.characters)) { result in
            self.view.finishLoading()
            switch result {
            case .success(let characters):
                self.view.setCharacters(characters: characters)
            case .failure(let error):
                self.view.showErrorAlert(withMessage: error.localizedDescription)
            }
        }
    }
}

