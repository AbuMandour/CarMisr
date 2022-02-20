//
//  PercentLayoutConstraint.swift
//  MvvmWhite
//
//  Created by Muhammad Abumandour on 16/01/2022.
//

import Foundation
import UIKit


public class PercentLayoutConstraint : NSLayoutConstraint{
    
    @IBInspectable var constantPercent : CGFloat = 0 {
        didSet{
            layoutDidChange()
        }
    }
    
    var screenSize: (width: CGFloat, height: CGFloat) {
        return (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
        
    public override func awakeFromNib() {
        super.awakeFromNib()
        guard constantPercent > 0 else { return }
        NotificationCenter.default.addObserver(self,
            selector: #selector(layoutDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
    }
        
    
    //Re-calculate constant based on orientation and percentage.
    @objc func layoutDidChange() {
        guard constantPercent > 0 else { return }
        switch firstAttribute {
            case .top, .topMargin, .bottom, .bottomMargin:
                constant = screenSize.height * constantPercent
            case .leading, .leadingMargin, .trailing, .trailingMargin:
                constant = screenSize.width * constantPercent
            default: break
        }
    }
        
    deinit {
        guard constantPercent > 0 else { return }
        NotificationCenter.default.removeObserver(self)
    }
}
