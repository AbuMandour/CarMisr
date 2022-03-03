//
//  CarModelDetails.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import Foundation

class CarModelDetailsService : CarModelDetailsProtocol {
    
    func getSpecsForModel(model: Model) -> [ModelSpecs] {
        var modelSpecs = [ModelSpecs]()
        modelSpecs.append(.basic(BasicModelSpecs(key: "Engine Type", value: model.engineType)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Engine Size", value: model.engineSize)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Transmission Type", value: model.transmissionType)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Vehicle Style", value: model.vehicleStyle)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Vehicle Size", value: model.vehicleSize)))
        modelSpecs.append(.basic(BasicModelSpecs(key: "Number Of Seats", value: model.numberOfSeats)))
        modelSpecs.append(.multi(MultiModelSpecs(key: "Colors", values: model.colors)))
        return modelSpecs
    }
    
}
