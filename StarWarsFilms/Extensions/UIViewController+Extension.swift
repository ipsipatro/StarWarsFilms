//
//  UIViewController+Extension.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

extension UIViewController {
    private static var storyboardId: String {
        return String(describing: self)
    }

    static func instantiate(from storyboard: UIStoryboard) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
}
