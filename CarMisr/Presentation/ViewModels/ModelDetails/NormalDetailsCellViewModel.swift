//
//  NormalModelDetailsCellViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation
import RxCocoa
import RxSwift

final class NormalDetailsCellViewModel{
    
    //MARK: - Properties
    let basicModelSpecs: BasicModelSpecs
    struct Input{
        let tigger: Driver<Void>
    }
    struct Output{
        let key: Driver<String>
        let value: Driver<String>
    }
    
    //MARK: - Initailizer
    init(basicModelSpecs: BasicModelSpecs) {
        self.basicModelSpecs = basicModelSpecs
    }
    
    //MARK: - Internal Method
    
    func transform(input: Input) -> Output {
        let key: Driver<String> = input.tigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else { return Driver.empty() }
                return Driver.just(self.basicModelSpecs.key)
            }
        let value: Driver<String> = input.tigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else { return Driver.empty() }
                return Driver.just(self.basicModelSpecs.value)
            }
        
        return Output(key: key, value: value)
    }
}
