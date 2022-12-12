//
//  CarStyleData.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 01/03/2022.
//

import Foundation

// MARK: - CarStyleData
struct CarStyleData: Codable {
    let totalNumber: Int?
    let totalPages: Int?
    let styles: [StylesData]?
    
    enum CodingKeys: String, CodingKey {
        case styles = "results"
        case totalNumber = "totalNumber"
        case totalPages = "totalPages"
    }
}

// MARK: - Result
struct StylesData: Codable {
    let id: Int?
    let modelNiceName: String?
    let modelId: String?
    let transmissionType: String?
    let engineType: String?
    let engineSize: Double?
    let numberOfSeats: Int?
    let categories: Categories?
    let name: String?
    let niceName: String?
}

// MARK: - Categories
struct Categories: Codable {
    let primaryBodyType: [String]?
    let vehicleType: [String]?
    let crossover: [String]?
    let vehicleStyle: [String]?
    let market: [String]?
    let vehicleSize: [String]?

    enum CodingKeys: String, CodingKey {
        case primaryBodyType = "PRIMARY_BODY_TYPE"
        case vehicleType = "Vehicle Type"
        case crossover = "Crossover"
        case vehicleStyle = "Vehicle Style"
        case market = "Market"
        case vehicleSize = "Vehicle Size"
    }
}
