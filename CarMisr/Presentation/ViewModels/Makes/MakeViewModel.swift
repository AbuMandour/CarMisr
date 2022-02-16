//
//  MakeViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import RxSwift
import RxCocoa


final class MakeViewModel{
        
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var makes = PublishRelay<[Make]>()
    private var tempMakes = [Make]()
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var isLoadMore = BehaviorRelay<Bool>(value: false)
    private var message = PublishRelay<String>()
    private var canLoadMore = true
    private var pageNumber = 0
    
    struct Input {
        let didAppear: ControlEvent<Void>
        let makeSelected: ControlEvent<Make>
        let loadMore: Driver<Bool>
    }
    
    struct Output{
        let makes: Observable<[Make]>
        let isloading: Observable<Bool>
        let isloadMore: Observable<Bool>
        let message: Observable<String>
    }
    
    //MARK: - Initailizer
    init() { }
        
    //MARK: - Public Method
    func transform(input: Input) -> Output{
        
        input.didAppear
            .bind { [weak self] (_) in
                guard let self = self else { return }
                self.loadData()
            }.disposed(by: disposeBag)
        
        input.makeSelected
            .bind { [weak self] make in
                guard let self = self else { return }
                self.showModels(make: make)
            }.disposed(by: disposeBag)
        
        input.loadMore
            .drive { [weak self] shouldLoadMore in
                guard let self = self else { return }
                self.loadMore(shouldLoadMore: shouldLoadMore)
            }.disposed(by: disposeBag)
        
        return Output(makes: makes.asObservable(), isloading: isLoading.asObservable(), isloadMore: isLoadMore.asObservable(), message: message.asObservable())
    }
    
    //MARK: - Internal Method
    private func loadData(){
        isLoading.accept(true)
        tempMakes.removeAll()
        pageNumber = 0
        canLoadMore = true
        Task{ await requestMakes() }
        isLoading.accept(false)
    }
        
    private func loadMore(shouldLoadMore: Bool){
        if shouldLoadMore && self.canLoadMore && !self.tempMakes.isEmpty{
            isLoadMore.accept(true)
            pageNumber += 1
            Task{ await requestMakes() }
            isLoadMore.accept(false)
        }
    }
    
    private func requestMakes() async{
        try? await Task.sleep(nanoseconds: 3000000000)
    }
    
    private func showModels(make: Make){
        
    }
}
