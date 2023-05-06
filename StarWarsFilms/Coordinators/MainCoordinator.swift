//
//  MainCoordinator.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

class MainCoordinator: Coordinator {
    private let window: UIWindow?
    private var navigationController: UINavigationController
    private let httpConnectionManager: HttpConnectionCapable
    
    var filmsCoordinator: Coordinator?
    
    init(window: UIWindow?,
         navigationController: UINavigationController = UINavigationController(), httpConnectionManager: HttpConnectionCapable = HttpConnectionManager()) {
        self.window = window
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        self.httpConnectionManager = httpConnectionManager
        setupWindow()
        setupStarterCoordinator()
    }
    
    func setupWindow() {
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func setupStarterCoordinator() {
        filmsCoordinator = FilmsCoordinator(navigationController: navigationController, httpConnectionManager: httpConnectionManager)
    }
    
    func start() {
        filmsCoordinator?.start()
    }
}
