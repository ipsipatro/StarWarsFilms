//
//  StarWarsFilmDetailsViewController.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

// Protocol with the methods to be called from presenter
protocol StarWarsFilmDetailsView: AnyObject {
    func showErrorAlert(withMessage message: String) 
    func setCharacters(characters: [Character])
    func startLoading()
    func finishLoading()
}

class StarWarsFilmDetailsViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Private variables
    private var presenter: StarWarsFilmDetailsPresenter?
    private let adapter = CharactersAdapter()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
        configureUI()
    }
    
    func setPresenter(presenter: StarWarsFilmDetailsPresenter) {
        self.presenter = presenter
    }
    
    // MARK: - UI
    private func configureUI() {
        self.title = Constants.charactersTitle
        tableView.dataSource = adapter
        
        self.tableView.register(UINib(nibName: StarWarsCharacterTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: StarWarsCharacterTableViewCell.reuseIdentifier)
    }
}

extension StarWarsFilmDetailsViewController: StarWarsFilmDetailsView {
    func showErrorAlert(withMessage message: String) {
        ViewHelper.showErrorAlert(withMessage: message, viewController: self)
    }
    
    func setCharacters(characters: [Character]) {
        adapter.list = characters
        self.tableView.reloadData()
    }
    
    func startLoading() {
        loadingView.isHidden = false
    }
    
    func finishLoading() {
        self.loadingView.isHidden = true
    }
}


