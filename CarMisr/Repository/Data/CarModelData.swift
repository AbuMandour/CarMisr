//
//  CarModelData.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 20/02/2022.
//

import Foundation


// MARK: - CarModelData
struct CarModelData: Codable {
    let totalNumber, totalPages: Int?
    let models: [ModelData]?
    
    enum CodingKeys: String, CodingKey {
        case totalNumber = "totalNumber"
        case totalPages = "totalPages"
        case models = "results"
    }
}

// MARK: - Result
struct ModelData: Codable {
    let id: String?
    let name: String?
    let niceName: String?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case niceName = "niceName"
    }
}
