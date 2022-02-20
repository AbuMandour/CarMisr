//
//  CarModelProtocol.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 20/02/2022.
//

import Foundation

protocol CarModelProtocol{
    func getCarModels(makeNiceName: String, pageNumber: Int) async -> Result<[Model], DataError>
}
