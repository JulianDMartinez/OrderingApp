//
//  OrderViewController.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/10/21.
//

import UIKit

class OrderViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Your Order"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }
   
}
