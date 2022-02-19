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
}

// MARK: - Result
struct MakeData: Codable {
    let id: Int?
    let name: String?
    let niceName: String?
    let adTargetID: String?
    let niceID: String?
    let useInUsed: UseIn?
    let useInNew: UseIn?
    let useInPreProduction: UseIn?
    let useInFuture: UseIn?
    let attributeGroups: AttributeGroups?
    let models: [ModelData]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case niceName = "niceName"
        case adTargetID = "adTargetId"
        case niceID = "niceId"
        case useInUsed = "useInUsed"
        case useInNew = "useInNew"
        case useInPreProduction = "useInPreProduction"
        case useInFuture = "useInFuture"
        case attributeGroups = "attributeGroups"
        case models = "models"
    }
}

// MARK: - AttributeGroups
struct AttributeGroups: Codable {
}

// MARK: - Model
struct ModelData: Codable {
    let id: String?
    let name: String?
    let niceName: String?
    let href: String?
}

enum UseIn: String, Codable {
    case n = "N"
    case y = "Y"
}
