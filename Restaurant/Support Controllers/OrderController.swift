//
//  OrderController.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/18/21.
//

import UIKit

struct OrderController {
    static var shared = OrderController()
    var orderItems = [MenuItem]()
    var orderItemImages = [UIImage]()
    var orderCount = 0
}
