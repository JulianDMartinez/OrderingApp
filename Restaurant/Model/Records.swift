//
//  Record.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/10/21.
//

import Foundation

struct Records: Codable {
    struct Fields: Codable {
        struct Image: Codable {
            struct Thumbnails: Codable {
                struct Full: Codable {
                    let height: Int
                    let url: URL
                    let width: Int
                }

                struct Large: Codable {
                    let height: Int
                    let url: URL
                    let width: Int
                }

                struct Small: Codable {
                    let height: Int
                    let url: URL
                    let width: Int
                }

                let full: Full
                let large: Large
                let small: Small
            }

            let filename: String
            let id: String
            let size: Int
            let thumbnails: Thumbnails
            let type: String
            let url: URL
        }

        let category: String
        let description: String
        let estimatedPrepTime: Int
        let id: Int
        let image: [Image]
        let name: String
        let price: Double

        private enum CodingKeys: String, CodingKey {
            case category
            case description
            case estimatedPrepTime = "estimated_prep_time"
            case id
            case image
            case name
            case price
        }
    }

    let fields: Fields
}
