//
//  SequenceExtension.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 01/03/2022.
//

import Foundation

extension Sequence where Element : Hashable{
    func uniqueValues() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
