//
//  ViewHelper.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

class ViewHelper {
    static func showErrorAlert(withMessage message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: Constants.alertTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okTitle, style: .default)
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }
}
