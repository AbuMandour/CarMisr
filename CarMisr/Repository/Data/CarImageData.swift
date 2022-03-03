//
//  ModelImagesData.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 22/02/2022.
//

import Foundation

// MARK: - ModelImagesData
struct CarImageData: Codable {
    let photosData: [PhotoData]?
    let photosCount: Int?
    let links: [Link]?
    
    enum CodingKeys: String, CodingKey {
        case photosData = "photos"
        case photosCount = "photosCount"
        case links = "links"
    }
}

// MARK: - Link
struct Link: Codable {
    let rel: Rel?
    let href: String?
}

enum Rel: String, Codable {
    case first = "first"
    case last = "last"
    case next = "next"
    case relSelf = "self"
}

// MARK: - Photo
struct PhotoData: Codable {
    let title: String?
    let category: ImageCategory?
    let tags: [String]?
    let provider: Provider?
    let sources: [Source]?
    let years, submodels, trims: [String]?
    let modelYearID: Int?
    let shotTypeAbbreviation: String?
    let styleIDS, exactStyleIDS: [String]?

    enum CodingKeys: String, CodingKey {
        case title, category, tags, provider, sources, years, submodels, trims
        case modelYearID = "modelYearId"
        case shotTypeAbbreviation
        case styleIDS = "styleIds"
        case exactStyleIDS = "exactStyleIds"
    }
}

enum ImageCategory: String, Codable {
    case exterior = "EXTERIOR"
    case interior = "INTERIOR"
}

enum Provider: String, Codable {
    case oem = "OEM"
}

// MARK: - Source
struct Source: Codable {
    let link: Link?
    let sourceExtension: Extension?
    let size: Size?

    enum CodingKeys: String, CodingKey {
        case link
        case sourceExtension = "extension"
        case size
    }
}

// MARK: - Size
struct Size: Codable {
    let width, height: Int?
}

enum Extension: String, Codable {
    case jpg = "JPG"
}


