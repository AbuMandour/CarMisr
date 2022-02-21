//
//  CarMakeData.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 18/02/2022.
//

import Foundation

// MARK: - CarMakeData
struct CarMakeData: Codable {
    let totalNumber: Int?
    let totalPages: Int?
    let makes: [MakeData]?
    
    enum CodingKeys: String, CodingKey {
        case totalNumber = "totalNumber"
        case totalPages = "totalPages"
        case makes = "results"
    }
}

// MARK: - Result
struct MakeData: Codable {
    let id: Int?
    let name: String?
    let niceName: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case niceName = "niceName"
    }
}
