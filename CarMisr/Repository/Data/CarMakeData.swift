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
    let adTargetID: String?
    let niceID: String?
    let useInUsed: String?
    let useInNew: String?
    let useInPreProduction: String?
    let useInFuture: String?
    let attributeGroups: MakeAttributeGroups?
    let models: [ModelMakeData]?

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
struct MakeAttributeGroups: Codable {
}

// MARK: - Model
struct ModelMakeData: Codable {
    let id: String?
    let name: String?
    let niceName: String?
    let href: String?
}

