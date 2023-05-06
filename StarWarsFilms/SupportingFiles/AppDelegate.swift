//
//  AppDelegate.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = MainCoordinator(window: window)
        coordinator?.start()
        return true
    }
}

