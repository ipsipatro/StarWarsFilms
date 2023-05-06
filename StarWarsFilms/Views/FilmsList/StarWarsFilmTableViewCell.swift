//
//  StarWarsFilmTableViewCell.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

class StarWarsFilmTableViewCell: UITableViewCell {
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    // MARK: - Configure cell
    func configure(film: Film) {
        self.titleLabel?.text = film.title
        self.directorLabel?.text = film.directorName
        self.producerLabel?.text = film.producerName
        self.releaseDateLabel?.text = film.releaseDateString
    }
}
