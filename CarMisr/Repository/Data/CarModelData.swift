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
    let makeID: Int?
    let makeName: String?
    let makeNiceName: String?
    let makeNiceID: String?
    let name, niceName, adTargetID, niceID: String?
    let modelLinkCode: String?
    let make: MakeModelData?
    let modelYears: [ModelYear]?
    let attributeGroups: ModelAttributeGroups?
    let categories: Categories?
    let categoryValues: [String]?
    let publicationStates: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case makeID = "makeId"
        case makeName, makeNiceName
        case makeNiceID = "makeNiceId"
        case name, niceName
        case adTargetID = "adTargetId"
        case niceID = "niceId"
        case modelLinkCode, make, modelYears, attributeGroups, categories, categoryValues, publicationStates
    }
}

// MARK: - AttributeGroups
struct ModelAttributeGroups: Codable {
    let main: Main?

    enum CodingKeys: String, CodingKey {
        case main = "MAIN"
    }
}

// MARK: - Main
struct Main: Codable {
    let id: Int?
    let name: String?
    let properties: Properties?
    let attributes: [String: Attribute]?
}

// MARK: - Attribute
struct Attribute: Codable {
    let id: Double?
    let name, value: String?
}

// MARK: - Properties
struct Properties: Codable {
    let useInNew: String?
    let epiCategoryID, year, modelLinkCode, epiCategoryName: String?
    let workflowstatus: String?
    let useInPreProduction, useInUsed: String?
    let name, dataAcquisitionDate: String?
    let minimumViableData: String?

    enum CodingKeys: String, CodingKey {
        case useInNew = "USE_IN_NEW"
        case epiCategoryID = "EPI_CATEGORY_ID"
        case year = "YEAR"
        case modelLinkCode = "MODEL_LINK_CODE"
        case epiCategoryName = "EPI_CATEGORY_NAME"
        case workflowstatus = "WORKFLOWSTATUS"
        case useInPreProduction = "USE_IN_PRE_PRODUCTION"
        case useInUsed = "USE_IN_USED"
        case name = "NAME"
        case dataAcquisitionDate = "DATA_ACQUISITION_DATE"
        case minimumViableData = "MINIMUM_VIABLE_DATA"
    }
}

// MARK: - Categories
struct Categories: Codable {
    let primaryBodyType, vehicleType, crossover, vehicleStyle: [String]?
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

// MARK: - Make
struct MakeModelData: Codable {
    let id: Int?
    let href: String?
}

// MARK: - ModelYear
struct ModelYear: Codable {
    let id: Int?
    let name: String?
    let year: Int?
    let publicationStates: [String]?
    let href: String?
}
