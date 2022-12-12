//
//  ApiProtocol.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import Foundation

public protocol ApiProtocol {
    
    func fetchItem<T:Codable>(urlRequest: URLRequest) async -> Result<T,ApiError>    
}
