//
//  ViewExtension.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import UIKit

extension UIView{
    
    @IBInspectable
    var cornerRadiusPercentageOfHeight: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let cornarRadiusValue = self.frame.height * newValue
            layer.cornerRadius = cornarRadiusValue
        }
    }
}
