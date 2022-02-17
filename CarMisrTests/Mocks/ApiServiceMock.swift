//
//  ApiServiceMock.swift
//  CarMisrTests
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation
@testable import CarMisr


class ApiServiceMock : ApiProtocol{
    
    enum Behavior {
        case alwaysFail
        case alwaysSucceed(Codable)
    }
    
    static var behavior: Behavior!
    
    func fetchItem<T>(urlString: String) async -> Result<T, ApiError> where T : Decodable & Encodable {
        switch Self.behavior{
        case .alwaysFail:
            return .failure(.InvaildData(nil))
        case .alwaysSucceed(let codable):
            return .success(codable as! T)
        case .none:
            return .failure(.InvaildData(nil))
        }
    }
    
    
}

