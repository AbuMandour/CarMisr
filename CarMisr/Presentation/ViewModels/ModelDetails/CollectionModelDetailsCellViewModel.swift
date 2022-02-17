//
//  CollectionModelDetailsCellViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import Foundation
import RxSwift
import RxCocoa


final class CollectionModelDetailsCellViewModel{
    
    //MARK: - Properties
    private let multiModelSpecs: MultiModelSpecs
    private let disposeBag = DisposeBag()
    private var values = PublishRelay<[String]>()
    struct Input{
        let tigger: Driver<Void>
    }
    struct Output{
        let key: Driver<String>
        let values: Observable<[String]>
    }
    
    //MARK: - Initailizer
    init(multiModelSpecs: MultiModelSpecs) {
        self.multiModelSpecs = multiModelSpecs
    }
    
    //MARK: - Internal Method
    
    func transform(input: Input) -> Output {
        let key: Driver<String> = input.tigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else { return Driver.empty() }
                return Driver.just(self.multiModelSpecs.key)
            }
        input.tigger
            .drive { [weak self] (_) in
                guard let self = self else { return }
                self.values.accept(self.multiModelSpecs.values)
            }.disposed(by: disposeBag)
        
        return Output(key: key, values: values.asObservable())
    }
}
