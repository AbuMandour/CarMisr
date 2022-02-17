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
    private var isLoading = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let didAppear: Driver<Void>
    }
    
    struct Output{
        let modelSpecs: Observable<[ModelSpecs]>
        let isloading: Observable<Bool>
    }
    
    //MARK: - Initailizer
    init() { }
        
    //MARK: - Public Method
    func transform(input: Input) -> Output{
        input.didAppear
            .drive { [weak self] (_) in
                guard let self = self else { return }
                self.loadData()
            }.disposed(by: disposeBag)
        return Output(modelSpecs: modelSpecs.asObservable(), isloading: isLoading.asObservable())
    }
    
    //MARK: - Internal Method
    private func loadData(){
        Task{
            isLoading.accept(true)
            await requestMakes()
            isLoading.accept(false)
        }
    }
            
    private func requestMakes() async{
        try? await Task.sleep(nanoseconds: 3000000000)
        modelSpecs.accept([ModelSpecs]())
    }

}
