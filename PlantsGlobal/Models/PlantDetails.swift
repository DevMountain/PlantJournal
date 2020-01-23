//
//  PlantVarieties.swift
//  PlantsGlobal
//
//  Created by Trevor Walker on 1/20/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation

// MARK: - Plants
struct TopLevelObject: Codable {
    let PlantDetails: PlantDetails
    let images: [Image]

    enum CodingKeys: String, CodingKey {
        case PlantDetails = "main_species"
        case images
    }
}

// MARK: - Image
struct Image: Codable {
    let url: String
}

// MARK: - PlantDetails
struct PlantDetails: Codable {
    let specifications: Specifications
    let scientificName: String
    let images: [Image]
    let familyCommonName, duration, commonName: String

    enum CodingKeys: String, CodingKey {
        case specifications
        case scientificName = "scientific_name"
        case images
        case familyCommonName = "family_common_name"
        case duration
        case commonName = "common_name"
    }
}

// MARK: - Specifications
struct Specifications: Codable {
    let toxicity: String
    let matureHeight: MatureHeight
    let growthRate, growthPeriod, growthHabit, growthForm: String

    enum CodingKeys: String, CodingKey {
        case toxicity
        case matureHeight = "mature_height"
        case growthRate = "growth_rate"
        case growthPeriod = "growth_period"
        case growthHabit = "growth_habit"
        case growthForm = "growth_form"
    }
}

// MARK: - MatureHeight
struct MatureHeight: Codable {
    let ft: Double
    let cm: Double
}
