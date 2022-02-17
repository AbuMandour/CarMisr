//
//  ColorCellViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation
import RxCocoa
import RxSwift

final class ColorCellViewModel{
    
    //MARK: - Properties
    private let colorHex: String
    private let disposeBag = DisposeBag()
    
    struct Input{
        let tigger: Driver<Void>
    }
    struct Output{
        let color: Driver<UIColor>
    }
    
    //MARK: - Initailizer
    init(colorHex: String) {
        self.colorHex = colorHex
    }
    
    //MARK: - Internal Method
    
    func transform(input: Input) -> Output {
        let color: Driver<UIColor> = input.tigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else { return Driver.empty() }
                return Driver.just(UIColor(hexString: self.colorHex))
            }
        
        return Output(color: color)
    }
}
