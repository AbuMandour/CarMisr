//
//  BaseViewCell.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import Foundation

protocol BaseViewCell{
    
 associatedtype Model
    func bind( _ model : Model)
}
