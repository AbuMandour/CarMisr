//
//  CarStyleProtocol.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import Foundation

protocol CarStyleProtocol{
    func getCarStyles(modelNiceName: String , pageNumber: Int) async -> Result<[Style], DataError>
}
