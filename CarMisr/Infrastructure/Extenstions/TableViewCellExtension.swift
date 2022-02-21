//
//  TableViewCellExtension.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 21/02/2022.
//

import UIKit

extension UITableViewCell : NameDescribable {
    static func nib () -> UINib {
        return UINib(nibName: self.typeName, bundle: nil)
    }
}
