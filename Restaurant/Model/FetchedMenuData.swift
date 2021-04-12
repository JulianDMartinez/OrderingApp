//
//  Results.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/10/21.
//

import Foundation

struct FetchedMenuData: Codable {
    
    let menuItem: [MenuItem]
    
    private enum CodingKeys: String, CodingKey {
        case menuItem = "records"
    }
}

