//
//  ObservableTypeExtenstion.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import RxCocoa
import RxSwift


extension ObservableType{
    
    func asDriverComplete() -> SharedSequence<DriverSharingStrategy,Element> {
        return asDriver(onErrorRecover: { (error)  in
            return Driver.empty()
        })
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
