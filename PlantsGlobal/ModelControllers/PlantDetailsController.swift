//
//  PlantDetailsController.swift
//  PlantsGlobal
//
//  Created by Trevor Walker on 1/22/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

class PlantDetailsController {
    static func getPlantDetails(plantId: Int, completion: @escaping (Result<PlantDetails, GenericErrors>) -> Void) {
        //Creating a Safe URL
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "trefle.io"
        urlComponents.path = "/api/plants/\(plantId)"
        //adding query items
        urlComponents.queryItems = [URLQueryItem(name: "token", value: "WUhNT0J3citlNy9Qa3A2RldhcTJOUT09")]
        
        //Creating out final URL
        guard let url = urlComponents.url else {completion(.failure(.invalidURL)) ;return}
        
        print(url)
        //Starting our URL Session
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Check Error
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            //Making sure that we have data
            guard let data = data else {completion(.failure(.noData)) ;return}
            print(data.prettyPrintedJSONString!)
            do {
                //Using the JSONDecoder to map the JSON, from data, onto our Plat Modal
                let decodedData: TopLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let receivedPlantDetails = decodedData.PlantDetails
                completion(.success(receivedPlantDetails))
            } catch {
                print("Failed")
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(urlString: String, completion: @escaping (Result<UIImage, GenericErrors>) -> Void) {
        guard let url: URL = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Check Error
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            //Making sure that we have data
            guard let data = data else {completion(.failure(.noData)) ;return}
            //Using the JSONDecoder to map the JSON, from data, onto our Plat Modal
            guard let decodedIamge: UIImage = UIImage(data: data) else { completion(.failure(.unableToDecode)); return}
            completion(.success(decodedIamge))
        }.resume()
    }
}

// MARK: - JSON bug testing
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
