//
//  MainCoordinator.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit

class MainCoordinator: AppCoordinator {
    var navigationStack: NavigationStackProtocol
    
    var childern = [AppCoordinator]()
    
    init( navigationStack: NavigationStackProtocol) {
        self.navigationStack = navigationStack
    }
    
    func start() {
        let makersViewController = MakeViewController(makeViewModel: MakeViewModel())
        navigationStack.push(viewController: makersViewController)
    }
    
}
