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
        
        if OrderController.shared.orderCount == 0 {
            if let tabItems = self.tabBarController?.tabBar.items {
                tabItems[1].badgeValue = "\(OrderController.shared.orderCount)"
                hideTabBarBadge(view: self.tabBarController!.tabBar)
            }
        }
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
        addToOrderButton.addTarget(self, action: #selector(addToOrderButtonTouchDown), for: .touchDown)
        addToOrderButton.addTarget(self, action: #selector(addToOrderButtonTouchUp), for: .touchUpInside)
        addToOrderButton.addTarget(self, action: #selector(addToOrderButtonTouchUp), for: .touchUpOutside)
        
        NSLayoutConstraint.activate([
            addToOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addToOrderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToOrderButton.heightAnchor.constraint(equalToConstant: 55),
            addToOrderButton.widthAnchor.constraint(equalTo: menuItemImageView.widthAnchor)
        ])
    }
    
    @objc func addToOrderButtonTouchDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            let scaleTransform = CGAffineTransform(scaleX: 0.993, y: 0.993)
            self.addToOrderButton.transform = scaleTransform
            self.addToOrderButton.backgroundColor = .systemGray5
        }
    }
    
    @objc func addToOrderButtonTouchUp() {
        
        if let tabItems = self.tabBarController?.tabBar.items {
            
            guard let menuItem = menuItem, let menuItemImage = menuItemImage else {
                print("An error was encountered while adding the menu item to order")
                return
            }
            
            OrderController.shared.orderCount += 1
            OrderController.shared.orderItems.append(menuItem)
            OrderController.shared.orderItemImages.append(menuItemImage)
            
            tabItems[1].badgeValue = "\(OrderController.shared.orderCount)"
            loopThrowViews(view: self.tabBarController!.tabBar)
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.05, options: .allowUserInteraction) {
            self.addToOrderButton.transform = CGAffineTransform.identity
            self.addToOrderButton.backgroundColor = .systemGray6
        }
        
    }
    
    func loopThrowViews(view:UIView){
        for subview in (view.subviews){
            let type = String(describing: type(of: subview))
            if type == "_UIBadgeView" {
                
                if subview.alpha == 0 {
                    subview.alpha = 1
                }
                
                animateView(view: subview)
            }
            else {
                loopThrowViews(view:subview)
            }
            
        }
    }
    
    func animateView(view: UIView){
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 3
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x:view.center.x, y:view.center.y - 1.5))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x:view.center.x, y:view.center.y + 1.5))
        view.layer.add(shakeAnimation, forKey: "position")
    }
    
    func hideTabBarBadge(view:UIView){
        for subview in (view.subviews){
            let type = String(describing: type(of: subview))
            if type == "_UIBadgeView" {
                subview.alpha = 0
            }
            else {
                hideTabBarBadge(view: subview)
            }
        }
    }
}
