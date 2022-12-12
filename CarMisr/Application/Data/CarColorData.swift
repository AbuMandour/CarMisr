//
//  CarColorData.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 01/03/2022.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let carColorData = try? newJSONDecoder().decode(CarColorData.self, from: jsonData)

import Foundation

// MARK: - CarColorData
struct CarColorData: Codable {
    let colors: [Color]?
    let colorsCount: Int?
}

// MARK: - Color
struct Color: Codable {
    let id, name, equipmentType, availability: String?
    let manufactureOptionName, manufactureOptionCode, category: String?
    let colorChips: ColorChips?
    let fabricTypes: [FabricType]?
    let price: Price?
}

// MARK: - ColorChips
struct ColorChips: Codable {
    let primary: Primary?
}

// MARK: - Primary
struct Primary: Codable {
    let r, g, b: Int?
    let hex: String?
}

// MARK: - FabricType
struct FabricType: Codable {
    let name, value: String?
}

// MARK: - Price
struct Price: Codable {
    let baseMSRP, baseInvoice: Int?
    let estimateTmv: Bool?
}
