//
//  ModelSpecs.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation

enum ModelSpecs {
    case basic(BasicModelSpecs)
    case multi(MultiModelSpecs)
}

struct BasicModelSpecs{
    var key:String
    var value: String
}

struct MultiModelSpecs{
    var key: String
    var values: [String]
}
