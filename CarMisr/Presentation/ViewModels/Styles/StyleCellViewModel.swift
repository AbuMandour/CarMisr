//
//  MakeCellViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import RxCocoa
import RxSwift

final class StyleCellViewModel {
    
    //MARK: - Properties
    
    let style: Style
        
    struct Input{
        let tigger: Driver<Void>
    }
    struct Output{
        let name: Driver<String>
    }
    
    //MARK: - Initailizer
    
    init(style: Style) {
        self.style = style
    }
    
    //MARK: - Internal Method
        
    func transform(input: Input) -> Output {
        let name: Driver<String> = input.tigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else { return Driver.empty() }
                return Driver.just(self.style.name)
            }
        return Output(name: name)
    }
    
}
