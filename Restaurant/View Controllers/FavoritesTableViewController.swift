//
//  FavoritesTableViewController.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/17/21.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
    }
    
    func configureVC() {
        title = "Favorites"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorStyle = .none
    }

    

}
