//
//  CharactersAdapter.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

class CharactersAdapter: NSObject, UITableViewDataSource {
    
    var list: [Character]?
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StarWarsCharacterTableViewCell.reuseIdentifier, for: indexPath) as? StarWarsCharacterTableViewCell else {
            assertionFailure("Missing StarWarsCharacterTableViewCell")
            return UITableViewCell()
        }
        guard let character = list?[indexPath.row] else { return cell }
        cell.configure(character: character)
        return cell
    }
}
