//
//  Style.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import Foundation

class Style : Equatable , Hashable   {
    internal init(id: Int, name: String,niceName: String, transmissionType: String, engineType: String, engineSize: String, numberOfSeats: String, vehicleStyle: String, vehicleType: String, colors: [String]) {
        self.id = id
        self.name = name
        self.transmissionType = transmissionType
        self.engineType = engineType
        self.engineSize = engineSize
        self.numberOfSeats = numberOfSeats
        self.vehicleStyle = vehicleStyle
        self.vehicleSize = vehicleType
        self.colors = colors
        self.niceName = niceName
    }
    
    var id: Int
    var name: String
    var niceName: String
    var transmissionType: String
    var engineType: String
    var engineSize: String
    var numberOfSeats: String
    var vehicleSize: String
    var vehicleStyle: String
    var colors: [String]
    
    static func == (lhs: Style, rhs: Style) -> Bool {
        lhs.niceName == rhs.niceName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(niceName)
    }
    
}
