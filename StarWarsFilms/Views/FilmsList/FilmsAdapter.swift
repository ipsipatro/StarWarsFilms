//
//  FilmAdapter.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

protocol FilmAdapterDelegate: AnyObject {
    func didTap(_ item: Film)
}

class FilmsAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var list: [Film]?
    
    weak var delegate: FilmAdapterDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StarWarsFilmTableViewCell.reuseIdentifier, for: indexPath) as? StarWarsFilmTableViewCell else {
            assertionFailure("Missing StarWarsFilmTableViewCell")
            return UITableViewCell()
        }
        guard let film = list?[indexPath.row] else { return cell }
        cell.configure(film: film)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = list?[indexPath.row] else { return }
        delegate?.didTap(item)
    }
}

