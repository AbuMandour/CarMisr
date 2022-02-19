//
//  CarMakeStub.swift
//  CarMisrTests
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation

//return 

struct CarMakeStub: Codable {
    let makes: [MakeStub]
}

// MARK: - Result
struct MakeStub: Codable {
    let name:String

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
