//
//  CarMakeService.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation

protocol CarMakeProtocol{
    func getCarMakes(pageNumber: Int) async -> Result<[Make],DataError>
}
