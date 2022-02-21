//
//  MakeViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import RxSwift
import RxCocoa
import Foundation


final class MakeViewModel{
        
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var makes = PublishRelay<[Make]>()
    private var tempMakes = [Make]()
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var isLoadMore = BehaviorRelay<Bool>(value: false)
    private var canLoadMore = true
    private var pageNumber = 0
    private var itemsCount = 0
    weak var coordinator: MainCoordinator?
    struct Input {
        let didAppear: Driver<Void>
        let refresh: Driver<Void>
        let makeSelected: ControlEvent<Make>
        let prefetchRows: ControlEvent<[IndexPath]>
    }
    struct Output{
        let makes: Observable<[Make]>
        let isloading: Observable<Bool>
        let isloadMore: Observable<Bool>
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
        
        input.refresh
            .drive { [weak self] (_) in
                guard let self = self else { return }
                self.loadData()
            }.disposed(by: disposeBag)
        
        input.makeSelected
            .bind { [weak self] make in
                guard let self = self else { return }
                self.showModels(make: make)
            }.disposed(by: disposeBag)
        
        input.prefetchRows
            .bind { [weak self] indexPaths in
                guard let self = self else { return }
                self.loadMore(prefetchRowsAt: indexPaths)
            }.disposed(by: disposeBag)
        
        return Output(makes: makes.asObservable(), isloading: isLoading.asObservable(), isloadMore: isLoadMore.asObservable())
    }
    
    //MARK: - Internal Method
    private func loadData(){
        Task{
            isLoading.accept(true)
            tempMakes.removeAll()
            pageNumber = 0
            canLoadMore = true
            await requestMakes()
            isLoading.accept(false)
        }
    }
        
    private func loadMore(prefetchRowsAt indexPaths: [IndexPath]){
        for index in indexPaths {
            if index.row >= itemsCount - 3 && canLoadMore && !isLoading.value {
                isLoadMore.accept(true)
                pageNumber += 1
                Task{ await requestMakes() }
                isLoadMore.accept(false)
                break
            }
        }
    }
    
    private func requestMakes() async{
        try? await Task.sleep(nanoseconds: 3000000000)
        makes.accept([Make]())
    }
    
    private func showModels(make: Make){
        coordinator?.selectModel(makeNiceName: make.niceName)
    }
}
