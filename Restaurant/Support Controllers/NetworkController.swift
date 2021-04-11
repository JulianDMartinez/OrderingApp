//
//  NetworkController.swift
//  Restaurant
//
//  Created by Julian Martinez on 4/10/21.
//

import UIKit

struct NetworkController {
    
    
    static let shared = NetworkController()
    
    func fetchRecords(completion: @escaping (Result<[Records], Error>) -> Void) {
        
        guard let baseURL = URL(string: "https://api.airtable.com/v0/applFdihEUrAxCd9X/Menu") else{
            print("An error was encountered while accessing the base URL")
            return
        }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems = [
            "api_key" : Constants.apiKey
        ].map{URLQueryItem(name: $0.key, value: $0.value)}
        
        guard let url = urlComponents?.url else {
            print("There was an error creating the fetchRecords URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let decodedData = try jsonDecoder.decode(FetchedMenuData.self, from: data)
                    completion(.success(decodedData.records))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchImage(menuItem: Records, completion: @escaping (Result<MenuItemImage, Error>) -> Void) {
        
        let imageURL = menuItem.fields.image[0].thumbnails.large.url
        
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data {
                guard let image = UIImage(data: data)
                else {
                    print("There was an error creating the image")
                    return
                }
                let imageID = menuItem.fields.id
                completion(.success(MenuItemImage(imageID: imageID, image: image)))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
