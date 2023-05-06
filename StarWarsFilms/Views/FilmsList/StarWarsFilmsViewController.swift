//
//  StarWarsFilmsViewController.swift
//  StarWarsFilms
//
//  Created by Ipsi Patro on 06/05/2023.
//

import UIKit

protocol StarWarsFilmsView: AnyObject {
    func showErrorAlert(withMessage message: String)
    func setFilms(films: [Film])
    func startLoading()
    func finishLoading()
}

class StarWarsFilmsViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Private variables
    private var presenter: StarWarsFilmsPresenter?
    private var films: [Film]?
    private let adapter = FilmsAdapter()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
        configureUI()
    }
    
    func setPresenter(presenter: StarWarsFilmsPresenter) {
        self.presenter = presenter
    }
    
    // MARK: - UI
    private func configureUI() {
        self.title = Constants.title
        
        tableView.delegate = adapter.self
        tableView.dataSource = adapter
        
        adapter.delegate = self
        self.tableView.register(UINib(nibName: StarWarsFilmTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: StarWarsFilmTableViewCell.reuseIdentifier)
    }
}

extension StarWarsFilmsViewController: FilmAdapterDelegate {
    func didTap(_ item: Film) {
        presenter?.didTapFilm(item)
    }
}

extension StarWarsFilmsViewController: StarWarsFilmsView {
    func showErrorAlert(withMessage message: String) {
        ViewHelper.showErrorAlert(withMessage: message, viewController: self)
    }
    
    func setFilms(films: [Film]) {
        adapter.list = films
        self.tableView.reloadData()
    }
    
    func startLoading() {
        loadingView.isHidden = false
    }
    
    func finishLoading() {
        self.loadingView.isHidden = true
    }
}
