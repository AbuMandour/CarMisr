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
    var navigationStack: NavigationStackProtocol {get set}
    func start()
}
