//
//  ColorCollectionViewCell.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 03/03/2022.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
            
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(colorHex: String){
        print(colorHex)
        self.backgroundColor = UIColor(hexString: colorHex)
        self.cornerRadiusPercentageOfHeight = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
    }
}
