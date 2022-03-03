//
//  ModelViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import Foundation
import RxCocoa
import RxSwift
import RxAlertViewable

final class ModelViewModel{
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var models = PublishRelay<[Model]>()
    private let alert = PublishRelay<RxAlert>()
    private var tempModels = [Model]()
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var isRefreshing = BehaviorRelay<Bool>(value: false)
    private var isLoadMore = BehaviorRelay<Bool>(value: false)
    private var canLoadMore = true
    private var pageNumber = 1
    var makeNiceName:String?
    weak var coordinator: MainCoordinator?
    var carModelService: CarModelProtocol!
    struct Input {
        let refresh: Driver<Void>
        let didAppear: Driver<Void>
        let modelSelected: ControlEvent<Model>
        let prefetchRows: ControlEvent<[IndexPath]>
    }
    struct Output{
        let models: Observable<[Model]>
        let isloading: Observable<Bool>
        let isloadMore: Observable<Bool>
        let isRefreshing: Observable<Bool>
        let alert: Observable<RxAlert>
    }
    
    //MARK: - Initailizer
    init(carModelService: CarModelProtocol) {
        self.carModelService = carModelService
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
        
        input.modelSelected
            .bind { [weak self] model in
                guard let self = self else { return }
                self.showModelDetails(model: model)
            }.disposed(by: disposeBag)
        
        input.prefetchRows
            .bind { [weak self] indexPaths in
                guard let self = self else { return }
                self.loadMore(prefetchRowsAt: indexPaths)
            }.disposed(by: disposeBag)
        
        return Output(models: models.asObservable(), isloading: isLoading.asObservable(),
                      isloadMore: isLoadMore.asObservable(), isRefreshing: isRefreshing.asObservable(), alert: alert.asObservable())
    }
    
    //MARK: - Internal Method
    private func loadData(){
        Task{
            isLoading.accept(true)
            tempModels.removeAll()
            pageNumber = 1
            canLoadMore = true
            await requestModels()
            isLoading.accept(false)
        }
    }
        
    private func refreshData(){
        Task{
            isRefreshing.accept(true)
            tempModels.removeAll()
            pageNumber = 1
            canLoadMore = true
            await requestModels()
            isRefreshing.accept(false)
        }
    }
    
    private func loadMore(prefetchRowsAt indexPaths: [IndexPath]){
        for index in indexPaths {
            if index.row >= tempModels.count - 3 && canLoadMore && !isLoading.value {
                isLoadMore.accept(true)
                pageNumber += 1
                Task{ await requestModels() }
                isLoadMore.accept(false)
                break
            }
        }
    }
    
    private func requestModels() async {
        guard let makeNiceName = makeNiceName else {
            return
        }
        let modelsResult = await carModelService.getCarModels(makeNiceName: makeNiceName, pageNumber: pageNumber) as Result<[Model],DataError>
        switch modelsResult {
        case .success(let newModels):
            tempModels.append(contentsOf: newModels)
            self.models.accept(tempModels)
        case .failure(let failureState):
            canLoadMore = false
            guard tempModels.isEmpty else {return}
            showNoModelsAlert(message: failureState.description)
        }
    }
    
    private func showModelDetails(model: Model){
        coordinator?.showModelDetails(model: model)
    }
    
    private func showNoModelsAlert(message: String){
        alert.accept(.error(message, onConfirm: { [weak self] in
            guard let self = self else {return}
            self.coordinator?.popModels()
        }))
    }

}
