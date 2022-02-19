//
//  DataError.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation

enum DataError : Error, Equatable {
    case error(String?)
    case empty(String)
}

extension DataError : CustomStringConvertible{
   public var description: String {
        switch self {
        case .error(let message):
            return message ?? ""
        case .empty(let message):
            return message
        }
    }
}
