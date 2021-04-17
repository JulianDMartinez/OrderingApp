//
//  NetworkController.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/10/21.
//

import UIKit

struct NetworkController {
    
    
    static let shared = NetworkController()
    
    func fetchMenuItems(completion: @escaping (Result<[MenuItem], Error>) -> Void) {
        
        guard let baseURL = URL(string: "https://api.airtable.com/v0/applFdihEUrAxCd9X/Menu") else{
            print("An error was encountered while accessing the fetchMenuItems base URL.")
            return
        }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems = [
            "api_key" : Constants.apiKey
        ].map{URLQueryItem(name: $0.key, value: $0.value)}
        
        guard let url = urlComponents?.url else {
            print("There was an error while creating the fetchMenuItems URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let decodedData = try jsonDecoder.decode(FetchedMenuData.self, from: data)
                    completion(.success(decodedData.menuItems))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchMenuItemImage(menuItem: MenuItem, completion: @escaping (Result<MenuItemImage, Error>) -> Void) {
        
        let imageURL = menuItem.properties.image[0].thumbnails.large.url
        
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data {
                guard let image = UIImage(data: data)
                else {
                    print("There was an error while creating a menu item image.")
                    return
                }
                let imageID = menuItem.properties.id
                completion(.success(MenuItemImage(imageID: imageID, image: image)))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
