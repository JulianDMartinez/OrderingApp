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
        
        contentConfiguration.text = menuItems[indexPath.row].properties.name
        contentConfiguration.imageProperties.maximumSize = CGSize(width: 200, height: 200)
        contentConfiguration.imageProperties.cornerRadius = 20
        
        if menuItemImages.count > indexPath.row {
            contentConfiguration.image = menuItemImages[indexPath.row].image
        } else {
            contentConfiguration.image = UIImage(systemName: "photo")
        }
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}
