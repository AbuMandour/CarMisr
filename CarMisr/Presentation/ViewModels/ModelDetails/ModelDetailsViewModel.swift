//
//  ModelDetailsViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation
import RxCocoa
import RxSwift

final class ModelDetailsViewModel{
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var modelSpecs = PublishRelay<[ModelSpecs]>()
    var model: Model?
    weak var coordinator: MainCoordinator?
    var carModelDetailsService: CarModelDetailsProtocol?
    struct Input {
        let didAppear: Driver<Void>
    }    
    struct Output{
        let modelSpecs: Observable<[ModelSpecs]>
    }
    
    //MARK: - Initailizer
    init(carModelDetailsService: CarModelDetailsProtocol) {
        self.carModelDetailsService = carModelDetailsService
    }
        
    //MARK: - Public Method
    func transform(input: Input) -> Output{
        input.didAppear
            .drive { [weak self] (_) in
                guard let self = self else { return }
                self.loadData()
            }.disposed(by: disposeBag)
        return Output(modelSpecs: modelSpecs.asObservable())
    }
    
    //MARK: - Internal Method
    private func loadData(){
        Task{
            requestModelSpecs()
        }
    }
            
    private func requestModelSpecs() {
        guard let model = model else {return}
        let specs = carModelDetailsService?.getSpecsForModel(model: model)
        modelSpecs.accept(specs ?? [ModelSpecs]())
    }

}
