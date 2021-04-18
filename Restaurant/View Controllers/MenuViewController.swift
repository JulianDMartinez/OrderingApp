//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/10/21.
//

import UIKit

class MenuViewController: UITableViewController {
    
    var menuItems = [MenuItem]()
    var menuItemImages = [MenuItemImage]()
    var menuCategories = [String]()
    
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        obtainMenu()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Menu"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }
    
    func obtainMenu() {
        NetworkController.shared.fetchMenuItems { result in
            switch result {
            case .success(let fetchedMenuItems):
                self.menuItems = fetchedMenuItems
                
                self.menuItems.sort { (first, second) -> Bool in
                    first.properties.id < second.properties.id
                }
                
                for item in self.menuItems {
                    
                    if !self.menuCategories.contains(item.properties.category) {
                        self.menuCategories.append(item.properties.category)
                    }
                    
                    NetworkController.shared.fetchMenuItemImage(menuItem: item) { result in
                        switch result {
                        case .success(let menuItemImage):
                            
                            self.menuItemImages.append(menuItemImage)
                            
                            self.menuItemImages.sort { (first, second) -> Bool in
                                first.imageID < second.imageID
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return menuCategories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemsInSection = calculateItemsInSection(section: section)
        return itemsInSection.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuCategories[section].capitalized
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        
        var backgroundConfiguration = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfiguration.backgroundColor = .systemGray6.withAlphaComponent(0.95)
        
        headerView.backgroundConfiguration = backgroundConfiguration
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemsInSection = calculateItemsInSection(section: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        let imageWidth = 180.0
        
        //Settting image size based on placeholder image aspect ratio to prevent cell labels from moving after network call
        let imageSize = CGSize(width: imageWidth, height: imageWidth/1.3653)
        
        contentConfiguration.text = itemsInSection[indexPath.row].properties.name
        contentConfiguration.secondaryText = priceFormatter.string(from: NSNumber(value: itemsInSection[indexPath.row].properties.price))
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .callout)
        contentConfiguration.secondaryTextProperties.color = .secondaryLabel
        contentConfiguration.imageProperties.maximumSize = imageSize
        contentConfiguration.imageProperties.cornerRadius = 10
        cell.accessoryType = .disclosureIndicator
        
        if menuItemImages.count > indexPath.row && itemsInSection.count > indexPath.row {
            for image in menuItemImages {
                if  image.imageID == itemsInSection[indexPath.row].properties.id {
                    contentConfiguration.image = ImageScaler.scaleToFill(image.image, in: imageSize)
                }
            }
        }
        
        if contentConfiguration.image == nil {
            if let placeholderImage = UIImage(systemName: "photo")?.withTintColor(.systemGray) {
                contentConfiguration.image = ImageScaler.scalePreservingAspectRatio(placeholderImage, targetSize: imageSize)
            } else {
                print("An error was encountered while accessing system image 'photo'.")
            }
        }
        
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemsInSection = calculateItemsInSection(section: indexPath.section)
        let destinationVC = MenuItemDetailViewController()
        
        destinationVC.menuItem = itemsInSection[indexPath.row]
        
        for image in menuItemImages {
            if itemsInSection[indexPath.row].properties.id == image.imageID {
                destinationVC.menuItemImage = image.image
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func calculateItemsInSection(section: Int) -> [MenuItem] {
        var itemsInSection = [MenuItem]()
        
        for item in menuItems {
            if item.properties.category == menuCategories[section] {
                itemsInSection.append(item)
            }
        }
        return itemsInSection
    }
}
