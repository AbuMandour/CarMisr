//
//  NavigationStack.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 21/02/2022.
//

import Foundation
import UIKit

class NavigationStack: NavigationStackProtocol {
    //MARK: - Properties
    var navigationController: UINavigationController?
    
    //MARK: - Internal Method
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func push(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
        
}
