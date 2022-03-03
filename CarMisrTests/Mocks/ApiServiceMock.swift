//
//  ApiServiceMock.swift
//  CarMisrTests
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation
@testable import CarMisr

class ApiServiceMock : ApiProtocol{
    
    func fetchItem<T>(urlRequest: URLRequest) async -> Result<T, ApiError> where T : Decodable, T : Encodable {
        switch self.behavior{
        case .alwaysFail:
            return .failure(.defaultError)
        case .alwaysSucceed(let codable):
            let result = codable.first { ($0 as? T) != nil }!
            return .success(result as! T)
        case .none:
            return .failure(.defaultError)
        }
    }
    var behavior: Behavior!
}

enum Behavior {
    case alwaysFail
    case alwaysSucceed([Codable])
}
