//
//  MediaEndPoint.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 22/02/2022.
//

import Foundation

enum MediaEndPoint{
    case image(path: String)
}

extension MediaEndPoint : BaseEndPoint{
    var baseURL: String {
        return Urls.baseMediaUrl
    }
    
    var path: String {
        switch self {
        case .image(let path):
            return path
        }
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    
}
