//
//  CollectionViewCellExtension.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import Foundation
import UIKit

extension UICollectionViewCell : NameDescribable{
    static func nib () -> UINib {
        return UINib(nibName: self.typeName, bundle: nil)
    }
}
