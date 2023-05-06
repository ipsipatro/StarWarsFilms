//
//  FilmsCoordinator.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit
import RealmSwift

class FilmsCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let connectionService: HttpConnectionCapable
    private let localStorageManager: LocalStorageManagable
    
    init(navigationController: UINavigationController = UINavigationController(), httpConnectionManager: HttpConnectionCapable) {
        self.navigationController = navigationController
        self.connectionService = httpConnectionManager
        let realm = try! Realm(configuration: Realm.Configuration.defaultConfiguration)
        self.localStorageManager = LocalStorageManager(realm)
    }
    
    func start() {
        showStarWarsFilmsListScreen()
    }
    
    private func showStarWarsFilmsListScreen() {
        let starWarsFilmsViewController = Factory.views.storyboards.main.starWarsFilmsViewController(delegate: self, connectionService: connectionService, localStorageManager: localStorageManager)
        navigationController.pushViewController(starWarsFilmsViewController, animated: true)
    }
}

extension FilmsCoordinator: StarWarsFilmsPresenterDelegate {
    func didTapFilm(_ film: Film) {
        let starWarsFilmDetailsViewController = Factory.views.storyboards.main.starWarsFilmDetailsViewController(film: film, connectionService: connectionService)
        navigationController.pushViewController(starWarsFilmDetailsViewController, animated: true)
    }
}
