//
//  MakeTableViewCell.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit

class MakeTableViewCell: UITableViewCell {

    @IBOutlet weak var makeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        makeNameLabel.text = nil
    }
    
}
