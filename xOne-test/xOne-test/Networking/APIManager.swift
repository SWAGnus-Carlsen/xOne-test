//
//  APIManager.swift
//  xOne-test
//
//  Created by Vitaliy Halai on 5.09.23.
//

import UIKit

final class APIManager {

    private init() {}
    
    static let shared = APIManager()
    
    
    
    func getCatBreeds(from urlString: String, completion: @escaping ([CatBreed]) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(APIConstants.authToken,
                         forHTTPHeaderField: APIConstants.nameOfHeader)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data, error == nil else { return }
            
            do {
                let jsonData = try JSONDecoder().decode([CatBreed].self, from: data)
                // print(try JSON(data: data))
                completion(jsonData)
            } catch {
                print("failed to convert \(#function): \(error)")
            }
        }
        task.resume()
    }
    
    func getCatImage(from urlString: String, completion: @escaping (CatImage) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(APIConstants.authToken,
                         forHTTPHeaderField: APIConstants.nameOfHeader)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data, error == nil else {
                
                return
                
            }
            
            do {
                let parsedData = try JSONDecoder().decode(CatImage.self, from: data)
                // print(try JSON(data: data))
                completion(parsedData)
            } catch {
                print("failed to convert \(#function): \(error)")
            }
        }
        task.resume()
    }
}
