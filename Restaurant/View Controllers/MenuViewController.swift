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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        obtainMenu()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Menu"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        let imageWidth = 200.0
        
        //Set image size based on placeholder image aspect ratio to prevent cell labels from moving after network call
        let imageSize = CGSize(width: imageWidth, height: imageWidth/1.3653)
        
        contentConfiguration.text = menuItems[indexPath.row].properties.name
        contentConfiguration.imageProperties.maximumSize = imageSize
        contentConfiguration.imageProperties.cornerRadius = 10
        
        if menuItemImages.count > indexPath.row {
            contentConfiguration.image = ImageScaler.scaleToFill(menuItemImages[indexPath.row].image, in: imageSize)
        } else {
            if let placeholderImage = UIImage(systemName: "photo")?.withTintColor(.systemGray) {
                contentConfiguration.image = ImageScaler.scalePreservingAspectRatio(placeholderImage, targetSize: imageSize)
            } else {
                print("System image 'photo' may have been deprecated. Check SF Symbols")
            }
        }
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}
