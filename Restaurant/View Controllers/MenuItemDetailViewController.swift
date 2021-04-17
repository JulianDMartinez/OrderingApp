//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/16/21.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    //Data Formatters
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter
    }()
    
    //Data
    var menuItemImage = UIImage(systemName: "photo")?.withTintColor(.systemGray)
    var menuItem: MenuItem?
    
    
    //Views
    let menuItemNameLabel = UILabel()
    let menuItemImageView = UIImageView()
    let menuItemDescriptionView = UITextView()
    let addToOrderButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureMenuItemNameLabel()
        configureImageView()
        configureDescriptionView()
        configureAddToOrderButton()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
    }
    
    func configureMenuItemNameLabel() {

        view.addSubview(menuItemNameLabel)
        
        guard let menuItemName = menuItem?.properties.name else {
            print("An error was encountered while retrieving item name in Detail Screen")
            return
        }
        
        menuItemNameLabel.text = menuItemName
        menuItemNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        menuItemNameLabel.adjustsFontSizeToFitWidth = true
        menuItemNameLabel.textAlignment = .center
        menuItemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuItemNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuItemNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuItemNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
        
    }
    
    func configureImageView() {
        
        
        
        guard let menuItemImage = menuItemImage else {
            print("An error was encountered while accessing the image for the Detail Screen.")
            return
        }
        
        view.addSubview(menuItemImageView)
        
        menuItemImageView.contentMode = .scaleAspectFill
        menuItemImageView.layer.cornerRadius = 10
        menuItemImageView.clipsToBounds = true
        menuItemImageView.image = menuItemImage
        menuItemImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            menuItemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuItemImageView.topAnchor.constraint(equalTo: menuItemNameLabel.bottomAnchor, constant: 30),
            menuItemImageView.widthAnchor.constraint(equalToConstant: 320),
            menuItemImageView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func configureDescriptionView() {
        view.addSubview(menuItemDescriptionView)
        
        guard let menuItemDescription = menuItem?.properties.description else {
            print("An error was encountered while retrieving item description in Detail Screen")
            return
        }
        
        menuItemDescriptionView.text = menuItemDescription
        menuItemDescriptionView.font = UIFont.preferredFont(forTextStyle: .body)
        menuItemDescriptionView.isScrollEnabled = true
        menuItemDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        menuItemDescriptionView.isEditable = false
        
        NSLayoutConstraint.activate([
            menuItemDescriptionView.topAnchor.constraint(equalTo: menuItemImageView.bottomAnchor, constant: 20),
            menuItemDescriptionView.widthAnchor.constraint(equalTo: menuItemImageView.widthAnchor, multiplier: 1.2),
            menuItemDescriptionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuItemDescriptionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
    }
    
    func configureAddToOrderButton() {
        view.addSubview(addToOrderButton)
        
        addToOrderButton.backgroundColor = .systemGray6
        addToOrderButton.setTitleColor(.label, for: .normal)
        addToOrderButton.layer.cornerRadius = 10
        addToOrderButton.layer.borderWidth = 0.1
        addToOrderButton.clipsToBounds = true
        
        guard let menuItemPrice = menuItem?.properties.price else {
            print("An error was encountered while retrieving item price in Detail Screen")
            return
        }
        
        guard let priceString = priceFormatter.string(from: NSNumber(value: menuItemPrice)) else {
            print("An error was encountered while formatting price.")
            return
        }
        
        addToOrderButton.setTitle("Add to Order - \(priceString)", for: .normal)
        
        addToOrderButton.titleLabel?.numberOfLines = 0
        
        addToOrderButton.translatesAutoresizingMaskIntoConstraints = false
        
        addToOrderButton.addTarget(self, action: #selector(addToOrderButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addToOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addToOrderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToOrderButton.heightAnchor.constraint(equalToConstant: 55),
            addToOrderButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
    }
    
    @objc func addToOrderButtonTapped() {
        print("Button tapped")
    }
}
