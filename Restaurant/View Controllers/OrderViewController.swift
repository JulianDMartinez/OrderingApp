//
//  OrderViewController.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/10/21.
//

import UIKit

class OrderViewController: UITableViewController {
    
    //Data Formatters
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter
    }()
    
    //Data
    var orderItems = OrderController.shared.orderItems
    var orderItemImages = OrderController.shared.orderItemImages
    var orderTotal: Double = {
        var total = 0.0
        for item in OrderController.shared.orderItems {
            total += item.properties.price
        }
        return total
    }()
    
    //Views
    let totalLabel = UILabel()
    let checkoutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCheckoutButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        tableView.isEditing = false
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Your Order"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.allowsSelection = false
    }

    
    func configureCheckoutButton() {
        view.addSubview(checkoutButton)
        
        checkoutButton.backgroundColor = .systemGray6
        checkoutButton.setTitleColor(.label, for: .normal)
        checkoutButton.layer.cornerRadius = 10
        checkoutButton.layer.borderWidth = 0.1
        checkoutButton.clipsToBounds = true

        
        guard let priceString = priceFormatter.string(from: NSNumber(value: orderTotal)) else {
            print("An error was encountered while formatting price.")
            return
        }
        
        checkoutButton.setTitle("Pay for Order - \(priceString)", for: .normal)
        checkoutButton.titleLabel?.numberOfLines = 0
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTouchDown), for: .touchDown)
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTouchUp), for: .touchUpInside)
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTouchUp), for: .touchUpOutside)
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            checkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkoutButton.heightAnchor.constraint(equalToConstant: 55),
            checkoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
    }
    
    @objc func checkoutButtonTouchDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            let scaleTransform = CGAffineTransform(scaleX: 0.993, y: 0.993)
            self.checkoutButton.transform = scaleTransform
            self.checkoutButton.backgroundColor = .systemGray5
        }
    }
    
    @objc func checkoutButtonTouchUp() {
        UIView.animate(withDuration: 0.1, delay: 0.05, options: .allowUserInteraction) {
            self.checkoutButton.transform = CGAffineTransform.identity
            self.checkoutButton.backgroundColor = .systemGray6
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        let imageWidth = 80.0
        
        //Settting image size based on placeholder image aspect ratio to prevent cell labels from moving after network call
        let imageSize = CGSize(width: imageWidth, height: imageWidth/1.3653)
        
        contentConfiguration.text = orderItems[indexPath.row].properties.name
        contentConfiguration.secondaryText = priceFormatter.string(from: NSNumber(value: orderItems[indexPath.row].properties.price))
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .callout)
        contentConfiguration.prefersSideBySideTextAndSecondaryText = true
        contentConfiguration.imageProperties.maximumSize = imageSize
        contentConfiguration.imageProperties.cornerRadius = 10
        contentConfiguration.image = orderItemImages[indexPath.row]
        
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            OrderController.shared.orderItems.remove(at: indexPath.row)
            OrderController.shared.orderItemImages.remove(at: indexPath.row)
            OrderController.shared.orderCount -= 1
            updateVCData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if OrderController.shared.orderCount == 0 {
                hideTabBarBadge(view: self.tabBarController!.tabBar)
            } else if let tabItems = self.tabBarController?.tabBar.items {
                tabItems[1].badgeValue = "\(OrderController.shared.orderCount)"
            }
        }
    }
    
    func updateVCData() {
        self.orderItems = OrderController.shared.orderItems
        self.orderItemImages = OrderController.shared.orderItemImages
        self.orderTotal = {
            var total = 0.0
            for item in OrderController.shared.orderItems {
                total += item.properties.price
            }
            return total
        }()
        configureCheckoutButton()
    }
    
    func updateUI() {
        updateVCData()
        tableView.reloadData()
    }
    
    func hideTabBarBadge(view:UIView){
        for subview in (view.subviews){
            let subViewType = String(describing: type(of: subview))
            if subViewType == "_UIBadgeView" {
                subview.alpha = 0
            }
            else {
                hideTabBarBadge(view: subview)
            }
        }
    }
    
   
}
