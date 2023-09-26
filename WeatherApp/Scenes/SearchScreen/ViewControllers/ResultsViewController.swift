//
//  ResultsViewController.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.03.2023.
//

import UIKit

protocol IResultsViewController: AnyObject {
    
    func showResults(with locations: [Location], and query: String)
}

final class ResultsViewController: UIViewController {
    
    var presenter: IResultsViewPresenter!
    
    private lazy var tableView = UITableView()
    private lazy var noResultsView = NoResultsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViews()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        tableView.backgroundColor = Color.main.black
        view.addSubview(tableView)
    }
    
    private func setupViews() {
        view.backgroundColor = Color.main.black
        let padding = view.bounds.height / 3
        noResultsView.isHidden = true
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noResultsView)
        
        NSLayoutConstraint.activate([
            noResultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding)
        ])
    }
}

extension ResultsViewController: IResultsViewController {
    
    func showResults(with locations: [Location], and query: String) {
        if locations.isEmpty {
            noResultsView.configure(with: query)
            tableView.isHidden = true
            noResultsView.isHidden = false
        } else {
            tableView.isHidden = false
            noResultsView.isHidden = true
        }
        tableView.reloadData()
    }
}

extension ResultsViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        presenter.numberOfResults()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.contentView.backgroundColor = .black
        cell.backgroundColor = .black
        
        let locationName = presenter.getResult(at: indexPath.row)
        let query = presenter.getQuery()
        let range = (locationName as NSString).range(of: query)
        let attributedString = NSMutableAttributedString(string: locationName)
        attributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: Color.main.white,
            range: range
        )
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = Color.translucent70.white
        content.textProperties.numberOfLines = 0
        content.attributedText = attributedString
        cell.contentConfiguration = content
        
        return cell
    }
}

extension ResultsViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter.showLocation(by: indexPath.item)
    }
}
