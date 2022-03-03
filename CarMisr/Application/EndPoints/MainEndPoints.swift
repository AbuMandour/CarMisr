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
    case styles((pageNumber: Int, modelNiceName: String))
    case modelImages((makeNiceName: String, modelNiceName: String))    
    case colors(styleId: Int)
}

extension MainEndPoints : BaseEndPoint{
    
    var baseURL: String {
        return Urls.baseUrl
    }
    
    var path: String {
        switch self {
        case .makes(_):
            return "/api/vehicle/v3/makes"        
        case .models((_, _)):
            return "/api/vehicle/v3/models"
        case .modelImages((let makeNiceName, let modelNiceName)):
            return "/api/media/v2/\(makeNiceName)/\(modelNiceName)/photos"
        case .colors(let styleId):
            return "/api/vehicle/v2/styles/\(styleId)/colors"
        case .styles:
            return "/api/vehicle/v3/styles"
        }
    }
    
    var parameters: [String : Any]? {
        var params = [String: Any]()
        switch self {
        case .makes(let pageNumber):
            params["pageNum"] = "\(pageNumber)"
            params["sortby"] = "name:asc"
            params["fields"] = "id,name,niceName"
        case .models((let pageNumber, let makeNiceName)):
            params["pageNum"] = "\(pageNumber)"
            params["makeNiceName"] = makeNiceName
            params["modelYears.year"] = "2022"
            params["publicationStates"] = "NEW"
            params["fields"] = "id,name,niceName"
        case .modelImages((_,_)):
            params["fmt"] = "json"
        case .colors(_):
            params["fmt"] = "json"
        case .styles((let pageNumber, let modelNiceName)):
            params["pageNum"] = "\(pageNumber)"
            params["modelNiceName"] = modelNiceName
            params["fields"] = "id,name,niceName,engineType,engineSize,transmissionType,numberOfSeats,categories,modelNiceName,modelId"
        }
        params["api_key"] = Keys.edmundsKey
        params["pageSize"] = "10"
        return params
    }
    
    
}
