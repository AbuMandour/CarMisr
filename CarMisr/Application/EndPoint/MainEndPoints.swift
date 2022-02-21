//
//  MainEndPoints.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 21/02/2022.
//

import Foundation


enum MainEndPoints {
    case makes(pageNumber: Int)
    case models((pageNumber: Int, makeNiceName: String))
}

extension MainEndPoints : BaseEndPoint{
    
    var baseURL: String {
        return Urls.baseUrl
    }
    
    var path: String {
        switch self {
        case .makes( _):
            return "/api/vehicle/v3/makes"
        case .models((_, _)):
            return "/api/vehicle/v3/models"
        }
    }
    
    var parameters: [String : Any]? {
        var params = [String: Any]()
        switch self {
        case .makes(let pageNumber):
            params["pageNum"] = "\(pageNumber)"
            params["sortby"] = "name:asc"
        case .models((let pageNumber, let makeNiceName)):
            params["pageNum"] = "\(pageNumber)"
            params["makeNiceName"] = "\(makeNiceName)"
            params["modelYears.year"] = "2022"
            params["publicationStates"] = "NEW"
        }
        params["pageSize"] = "10"
        params["api_key"] = Keys.edmundsKey
        params["fields"] = "id,name,niceName"
        return params
    }
    
    
}
