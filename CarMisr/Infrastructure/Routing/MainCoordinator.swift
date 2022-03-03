//
//  MainCoordinator.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit

class MainCoordinator: AppCoordinator {

    // MARK: Properties
    var navigationStack: NavigationStackProtocol
    var childern = [AppCoordinator]()
    
    // MARK: Initializers
    init( navigationStack: NavigationStackProtocol) {
        self.navigationStack = navigationStack        
    }
    
    // MARK: Public Methods
    func start() {
        let makeViewModel = MakeViewModel(carMakeService: CarMakeService(apiService: ApiService()))
        makeViewModel.coordinator = self
        let makersViewController = MakeViewController(makeViewModel: makeViewModel)
        navigationStack.push(viewController: makersViewController)
    }
    
    func selectModel(makeNiceName: String) {
        let modelViewModel = ModelViewModel(carModelService: CarModelService(apiService: ApiService()))
        modelViewModel.coordinator = self
        modelViewModel.makeNiceName = makeNiceName
        let modelViewController = ModelViewController(modelViewModel: modelViewModel)
        navigationStack.push(viewController: modelViewController)
    }
    
    func popModels() {
        navigationStack.pop()
    }
    
    func selectStyle(modelNiceName: String) {
        let styleViewModel = StylesViewModel(carStyleService: CarStyleService(apiService: ApiService()))
        styleViewModel.coordinator = self
        styleViewModel.modelNiceName = modelNiceName
        let styleViewController = StyleViewController(styleViewModel: styleViewModel)
        navigationStack.push(viewController: styleViewController)
    }
    
    func showDetails(style: Style) {
        let modelDetailsViewModel = ModelDetailsViewModel(carModelDetailsService: CarModelDetailsService())
        modelDetailsViewModel.style = style
        modelDetailsViewModel.coordinator = self
        let modelDetailsViewController = ModelDetailsViewController(modelDetailsViewModel: modelDetailsViewModel)
        navigationStack.push(viewController: modelDetailsViewController)
    }
}
