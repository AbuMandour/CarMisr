//
//  ApiServiceMock.swift
//  CarMisrTests
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation
@testable import CarMisr


class ApiServiceMock : ApiProtocol{
    
    var behavior: Behavior!
    
    func fetchItem<T: Codable>(urlString: String) async -> Result<T, ApiError>  {
        switch self.behavior{
        case .alwaysFail:
            return .failure(.defaultError)
        case .alwaysSucceed(let codable):
            return .success(codable as! T)
        case .none:
            return .failure(.defaultError)
        }
    }
}

enum Behavior {
    case alwaysFail
    case alwaysSucceed(Codable)
}
