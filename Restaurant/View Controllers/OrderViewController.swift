//
//  OrderViewController.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/10/21.
//

import UIKit

class OrderViewController: UITableViewController {
    
    var orderTotal = 0.00
    
    let totalLabel = UILabel()

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
    
    func configureMenuItemNameLabel() {
        
        view.addSubview(totalLabel)
        
        totalLabel.text = "\(orderTotal)"
        totalLabel.font = UIFont.boldSystemFont(ofSize: 30)
        totalLabel.adjustsFontSizeToFitWidth = true
        totalLabel.textAlignment = .center
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
        
    }
   
}
