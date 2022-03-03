//
//  ModelDetailsViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation
import RxCocoa
import RxSwift

final class DetailsViewModel{
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var modelSpecs = PublishRelay<[Details]>()
    var style: Style?
    weak var coordinator: MainCoordinator?
    var carDetailsService: CarDetailsProtocol?
    struct Input {
        let didAppear: Driver<Void>
    }    
    struct Output{
        let modelSpecs: Observable<[Details]>
    }
    
    //MARK: - Initailizer
    init(carDetailsService: CarDetailsProtocol) {
        self.carDetailsService = carDetailsService
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
        guard let style = style else {return}
        let specs = carDetailsService?.getSpecsForModel(style: style)
        modelSpecs.accept(specs ?? [Details]())
    }

}
