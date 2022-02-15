//
//  MainCoordinator.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit

class MainCoordinator: AppCoordinator {
    
    var childern = [AppCoordinator]()
    var navigationController : UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let makersViewController = MakeViewController()
        navigationController.pushViewController(makersViewController, animated: true)
    }
    
}
