//
//  StylesViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 02/03/2022.
//

import RxSwift
import RxCocoa
import Foundation
import RxAlertViewable

final class StyleViewModel{
        
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var styles = PublishRelay<[Style]>()
    private let alert = PublishRelay<RxAlert>()
    private var tempStyles = [Style]()
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var isLoadMore = BehaviorRelay<Bool>(value: false)
    private var canLoadMore = true
    private var pageNumber = 1
    weak var coordinator: MainCoordinator?
    var carStyleService: CarStyleProtocol!
    var modelNiceName:String?
    struct Input {
        let didAppear: Driver<Void>
        let refresh: Driver<Void>
        let styleSelected: ControlEvent<Style>
        let prefetchRows: ControlEvent<[IndexPath]>
    }
    struct Output{
        let styles: Observable<[Style]>
        let isloading: Observable<Bool>
        let isloadMore: Observable<Bool>
        let alert: Observable<RxAlert>
    }
    
    //MARK: - Initailizer
    init(carStyleService: CarStyleProtocol) {
        self.carStyleService = carStyleService
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
        
        input.styleSelected
            .bind { [weak self] style in
                guard let self = self else { return }
                self.showSpecs(style: style)
            }.disposed(by: disposeBag)
        
        input.prefetchRows
            .bind { [weak self] indexPaths in
                guard let self = self else { return }
                self.loadMore(prefetchRowsAt: indexPaths)
            }.disposed(by: disposeBag)
        
        return Output(styles: styles.asObservable(), isloading: isLoading.asObservable(), isloadMore: isLoadMore.asObservable(),
                      alert: alert.asObservable())
    }
    
    //MARK: - Internal Method
    private func loadData(){
        Task{
            isLoading.accept(true)
            tempStyles.removeAll()
            pageNumber = 1
            canLoadMore = true
            await requestStyles()
            isLoading.accept(false)
        }
    }
        
    private func refreshData(){
        Task{
            tempStyles.removeAll()
            pageNumber = 1
            canLoadMore = true
            await requestStyles()
            isLoading.accept(false)
        }
    }
    
    private func loadMore(prefetchRowsAt indexPaths: [IndexPath]){
        for index in indexPaths {
            if index.row >= tempStyles.count - 3 && canLoadMore && !isLoading.value {
                isLoadMore.accept(true)
                pageNumber += 1
                Task{ await requestStyles() }
                isLoadMore.accept(false)
                break
            }
        }
    }
    private func requestStyles() async {
        guard let modelNiceName = modelNiceName else { return}
        let stylesResult = await carStyleService.getCarStyles(modelNiceName: modelNiceName, pageNumber: pageNumber) as Result<[Style],DataError>
        switch stylesResult {
        case .success(let stylesModels):
            tempStyles.append(contentsOf: stylesModels)
            styles.accept(tempStyles)
        case .failure(let failureState):
            if failureState == .error(failureState.description){
                alert.accept(.error(failureState.description))
            }
            canLoadMore = false
        }
    }
    
    private func showSpecs(style: Style){
        coordinator?.showDetails(style: style)
    }
}
