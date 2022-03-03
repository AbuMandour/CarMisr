//
//  CarModelDetails.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import Foundation

class CarModelDetailsService : CarModelDetailsProtocol {
    
    func getSpecsForModel(style: Style) -> [ModelSpecs] {
        var modelSpecs = [ModelSpecs]()
        modelSpecs.append(.basic(BasicModelSpecs(key: "Engine Type", value: style.engineType)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Engine Size", value: style.engineSize)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Transmission Type", value: style.transmissionType)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Vehicle Style", value: style.vehicleStyle)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Vehicle Size", value: style.vehicleSize)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Number Of Seats", value: style.numberOfSeats)))
        modelSpecs.append(.multi(MultiModelSpecs(key: "Colors", values: style.colors)))
        return modelSpecs
    }
    
}
