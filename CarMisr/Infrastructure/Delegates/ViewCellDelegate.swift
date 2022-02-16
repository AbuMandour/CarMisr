//
//  ViewCellDelegate.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import Foundation


protocol ViewCellDelegate{
    associatedtype ViewModel
    func configure(_ viewModel: ViewModel)
}
