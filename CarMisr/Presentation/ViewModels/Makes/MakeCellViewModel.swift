//
//  MakeCellViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import RxCocoa
import RxSwift

final class MakeCellViewModel {
    
    //MARK: - Properties
    
    let model: Make
        
    struct Input{
        let tigger: Driver<Void>
    }
    struct Output{
        let name: Driver<String>
    }
    
    //MARK: - Initailizer
    
    init(model: Make) {
        self.model = model
    }
    
    //MARK: - Internal Method
        
    func transform(input: Input) -> Output {
        let name: Driver<String> = input.tigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else { return Driver.empty() }
                return Driver.just(self.model.name)
            }
        return Output(name: name)
    }
    
}
