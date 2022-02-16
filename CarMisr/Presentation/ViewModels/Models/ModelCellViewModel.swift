//
//  ModelCellViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import RxSwift
import RxCocoa


final class ModelCellViewModel{
    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    struct Input{
        let tigger: Driver<Void>
    }
    struct Output{
        let name: Driver<String>
        let imageUrl: Driver<URL>
    }
    
    //MARK: - Internal Method
    
    func transform(input: Input) -> Output {
        let name: Driver<String> = input.tigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else { return Driver.empty() }
                return Driver.just(self.model.name)
            }
        let imageUrl : Driver<URL> = input.tigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else { return Driver.empty() }
                guard let url = URL(string: self.model.imageUrl) else { return Driver.empty() }
                return Driver.just(url)
            }
        return Output(name: name, imageUrl: imageUrl )
    }
}

