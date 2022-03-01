//
//  CarModelProtocol.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 20/02/2022.
//

import Foundation

protocol CarModelProtocol{
    func getCarModels(makeNiceName: String, pageNumber: Int) async -> Result<[Model], DataError>
    func getCarModelNames(makeNiceName: String, pageNumber: Int) async -> Result<[Model],ApiError>
    func getModelImage(makeNiceName: String,modelNiceName: String) async -> String?
}
