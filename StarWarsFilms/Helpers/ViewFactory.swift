//
//  ViewFactory.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

struct ViewFactory {
    let storyboards = StoryboardFactory()
}

struct StoryboardFactory {
    let main = MainStoryboard()
}

struct MainStoryboard {
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    func starWarsFilmsViewController(delegate: StarWarsFilmsPresenterDelegate?, connectionService: HttpConnectionCapable, localStorageManager: LocalStorageManagable) -> StarWarsFilmsViewController {
        let starWarsFilmsViewController = StarWarsFilmsViewController.instantiate(from: storyboard) as! StarWarsFilmsViewController
        let presenter = StarWarsFilmsPresenter(delegate: delegate, view: starWarsFilmsViewController, connectionService: connectionService, localStorageManager: localStorageManager)
        starWarsFilmsViewController.setPresenter(presenter: presenter)
        return starWarsFilmsViewController
    }
    
    func starWarsFilmDetailsViewController(film: Film, connectionService: HttpConnectionCapable) -> StarWarsFilmDetailsViewController {
        let starWarsFilmDetailsViewController = StarWarsFilmDetailsViewController.instantiate(from: storyboard) as! StarWarsFilmDetailsViewController
        let presenter = StarWarsFilmDetailsPresenter(film: film, view: starWarsFilmDetailsViewController, connectionService: connectionService)
        starWarsFilmDetailsViewController.setPresenter(presenter: presenter)
        return starWarsFilmDetailsViewController
    }
}
