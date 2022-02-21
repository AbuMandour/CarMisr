//
//  MakeViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import RxSwift
import RxCocoa
import Foundation
import RxAlertViewable

final class MakeViewModel{
        
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var makes = PublishRelay<[Make]>()
    private let alert = PublishRelay<RxAlert>()
    private var tempMakes = [Make]()
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var isLoadMore = BehaviorRelay<Bool>(value: false)
    private var canLoadMore = true
    private var pageNumber = 1
    weak var coordinator: MainCoordinator?
    var carMakeService: CarMakeProtocol!
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
        let alert: Observable<RxAlert>
    }
    
    //MARK: - Initailizer
    init(carMakeService: CarMakeProtocol) {
        self.carMakeService = carMakeService
    }
        
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
                self.refreshData()
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
        
        return Output(makes: makes.asObservable(), isloading: isLoading.asObservable(), isloadMore: isLoadMore.asObservable(),
                      alert: alert.asObservable())
    }
    
    //MARK: - Internal Method
    private func loadData(){
        Task{
            isLoading.accept(true)
            tempMakes.removeAll()
            pageNumber = 1
            canLoadMore = true
            await requestMakes()
            isLoading.accept(false)
        }
    }
        
    private func refreshData(){
        Task{
            tempMakes.removeAll()
            pageNumber = 1
            canLoadMore = true
            await requestMakes()
            isLoading.accept(false)
        }
    }
    
    private func loadMore(prefetchRowsAt indexPaths: [IndexPath]){
        for index in indexPaths {
            if index.row >= tempMakes.count - 3 && canLoadMore && !isLoading.value {
                isLoadMore.accept(true)
                pageNumber += 1
                Task{ await requestMakes() }
                isLoadMore.accept(false)
                break
            }
        }
    }
    private func requestMakes() async {
        let makesResult = await carMakeService.getCarMakes(pageNumber: pageNumber) as Result<[Make],DataError>
        switch makesResult {
        case .success(let makeModels):
            tempMakes.append(contentsOf: makeModels)
            makes.accept(tempMakes)
        case .failure(let failureState):
            if failureState == .error(failureState.description){
                alert.accept(.error(failureState.description))
            }
            canLoadMore = false
        }
    }
    
    private func showModels(make: Make){
        coordinator?.selectModel(makeNiceName: make.niceName)
    }
}
