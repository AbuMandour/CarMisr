//
//  CarModelDetailsProtocol.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import Foundation

protocol CarModelDetailsProtocol{
    func getSpecsForModel(model: Model) -> [ModelSpecs]
}
