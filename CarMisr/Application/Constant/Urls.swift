//
//  Urls.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 18/02/2022.
//

import Foundation

struct Urls {
    
    static let baseUrl = "http://api.edmunds.com/api/vehicle/v3/"
    
    static func getMakesUrl(pageNumber: Int, pageSize: Int) -> String {
        "\(baseUrl)makes?api_key=\(Keys.edmundsKey)&pageNum=\(pageNumber)&pageSize=\(pageSize)"
    }
    
    static func getModelsUrl(makeNiceName: String, pageNumber: Int, pageSize: Int) -> String {        
        "\(baseUrl)models?makeNiceName=\(makeNiceName)&api_key=\(Keys.edmundsKey)&pageNum=\(pageNumber)&pageSize=\(pageSize)"
    }
    
}
