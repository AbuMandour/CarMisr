//
//  AppCoordinator.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import Foundation
import UIKit

protocol AppCoordinator{
    
    var childern: [AppCoordinator] {get set}
    var navigationController: UINavigationController {get set}
    func start()
}
