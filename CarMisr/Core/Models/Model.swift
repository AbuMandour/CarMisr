//
//  ModelVehicleModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import Foundation

class Model : Equatable , Hashable {
        
    internal init(id: String,name: String, niceName: String, imageUrl: URL) {
        self.id = id
        self.name = name
        self.niceName = niceName
        self.imageUrl = imageUrl
    }
    var id: String
    var name: String
    var niceName: String
    var imageUrl: URL
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
