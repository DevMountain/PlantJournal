//
//  PlantController.swift
//  PlantsGlobal
//
//  Created by Trevor Walker on 1/20/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation

class PlantController {
    //token=WUhNT0J3citlNy9Qa3A2RldhcTJOUT09&complete_data=true&page_size=100")!
//Our API Call
    static func GetPlants(queryItems: [URLQueryItem], completion: @escaping (Result<[Plant], GenericErrors>) -> Void) {
        //Creating a Safe URL with query items
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "trefle.io"
        urlComponents.path = "/api/plants"
        urlComponents.queryItems = queryItems
        
        //Creating out final URL
        guard let url = urlComponents.url else {completion(.failure(.invalidURL)) ;return}
        
        //Starting our URL Session
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Check Error
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            //Making sure that we have data
            guard let data = data else {completion(.failure(.noData)) ;return}
            do {
                //Using the JSONDecoder to map the JSON, from data, onto our Plat Modal
                let decodedData: [Plant] = try JSONDecoder().decode([Plant].self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Failed")
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}
