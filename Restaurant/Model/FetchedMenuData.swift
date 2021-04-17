//
//  Results.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/10/21.
//

import Foundation

struct FetchedMenuData: Codable {
    
    let menuItems: [MenuItem]
    
    private enum CodingKeys: String, CodingKey {
        case menuItems = "records"
    }
}

