//
//  GenericErrors.swift
//  PlantsGlobal
//
//  Created by Trevor Walker on 1/21/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//
import Foundation

enum GenericErrors: LocalizedError {
    //Our possible Errors
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    // Whatever info you think the user should know.
    var errorDescription: String? {
        switch self {
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .invalidURL:
            return "Unable to reach the server."
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "The server responded with bad data."
        }
    }
}
