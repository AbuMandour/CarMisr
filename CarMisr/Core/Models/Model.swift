//
//  ModelVehicleModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import Foundation

class Model : Equatable , Hashable {
    internal init(id: String, name: String, modelNiceName: String, imageUrl: URL, styleId: Int, transmissionType: String, engineType: String, engineSize: String, numberOfSeats: String, vehicleType: String, colors: [String]) {
        self.id = id
        self.name = name
        self.modelNiceName = modelNiceName
        self.imageUrl = imageUrl
        self.styleId = styleId
        self.transmissionType = transmissionType
        self.engineType = engineType
        self.engineSize = engineSize
        self.numberOfSeats = numberOfSeats
        self.vehicleType = vehicleType
        self.colors = colors
    }
    
    var id: String
    var name: String
    var modelNiceName: String
    var imageUrl: URL
    var styleId: Int
    var transmissionType: String
    var engineType: String
    var engineSize: String
    var numberOfSeats: String
    var vehicleType: String
    var colors: [String]
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
