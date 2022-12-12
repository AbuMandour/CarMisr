//
//  NavigationStackProtocol.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 21/02/2022.
//

import Foundation
import UIKit

protocol NavigationStackProtocol{
    func pop()
    func push(viewController: UIViewController)
}
