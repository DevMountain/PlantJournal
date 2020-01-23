//
//  Plant.swift
//  PlantsGlobal
//
//  Created by Trevor Walker on 1/20/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

struct Plant: Codable {
    let scientificName: String
    let id: Int
    let completeData: Bool
    let commonName: String?

    enum CodingKeys: String, CodingKey {
        case scientificName = "scientific_name"
        case id
        case completeData = "complete_data"
        case commonName = "common_name"
    }
}
