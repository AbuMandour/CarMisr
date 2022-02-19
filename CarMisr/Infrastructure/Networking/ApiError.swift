//
//  ApiError.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import Foundation

public enum ApiError : Error {
    case InvaildUrl
    case InvaildHttpResponse
    case InvaildStatusCode(Int)
    case InvaildData(Error?)
    case SerializeError(Error)
    case defaultError
}

extension ApiError : CustomStringConvertible{
    
   public var description: String {
        switch self {
        case .InvaildUrl:
            return "invaild url"
        case .InvaildHttpResponse:
            return "invaild http response"
        case .InvaildStatusCode(let int):
            return "invaild status code \(int)"
        case .InvaildData(let error):
            return "invaild data \(String(describing: error?.localizedDescription))"
        case .SerializeError(let error):
            return "error in data serialize: \(error)"
        case .defaultError:
            return ""
        }
    }
}
