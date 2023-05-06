//
//  UITableViewCell+Extension.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

protocol CellReusable {
    static var reuseIdentifier: String { get }
}

extension CellReusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellReusable {}
