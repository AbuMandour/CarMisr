//
//  ModelViewController.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlertViewable

class ModelViewController: UIViewController ,RxAlertViewable , UITableViewDelegate{

    //MARK: - Constants
    let cellIdentifier = "modelViewCell"
    
    //MARK: - Properties
    @IBOutlet weak var modelsTableView: UITableView!
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!
    private let modelViewModel: ModelViewModel!
    let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMakeTableView()
        bind()
        title = "Car Models"        
    }
    
    //MARK: - Initializer
    init(modelViewModel: ModelViewModel) {
        self.modelViewModel = modelViewModel
        super.init(nibName: "ModelViewController", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal Method
    private func setupMakeTableView(){
        modelsTableView.register(ModelTableViewCell.nib(), forCellReuseIdentifier: cellIdentifier)
        modelsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        modelsTableView.refreshControl = refreshControl
        modelsTableView.rowHeight = 274
    }
    
    private func bind(){
        let refreshTable = refreshControl.rx.controlEvent(.valueChanged).mapToVoid().asDriverComplete()
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:))).take(1).mapToVoid().asDriverComplete()
        let prefetchDataSource = modelsTableView.rx.prefetchRows
        let input = ModelViewModel.Input(refresh: refreshTable,
                                         didAppear: viewDidAppear,
                                         modelSelected: modelsTableView.rx.modelSelected(Model.self),
                                         prefetchRows: prefetchDataSource)
        let outup = modelViewModel.transform(input: input)
        outup.models
            .bind(to: modelsTableView.rx.items(cellIdentifier: cellIdentifier, cellType: ModelTableViewCell.self)) { (row, model, cell) in
                cell.configure(.init(model: model))
            }
            .disposed(by: disposeBag)
        outup.models
            .map ({ $0.count <= 0})
            .distinctUntilChanged()
            .bind(to: modelsTableView.rx.isEmpty(message: Defaults.noDataString))
            .disposed(by: disposeBag)
        outup.isloading
            .observe(on: MainScheduler.instance)
            .map(!)
            .bind(to: mainActivityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        outup.isloading
            .observe(on: MainScheduler.instance)
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        outup.isloadMore
            .observe(on: MainScheduler.instance)
            .map(!)
            .bind(to: loadMoreActivityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        outup.alert
            .observe(on: MainScheduler.instance)
            .bind(to: self.rx.alert)
            .disposed(by: disposeBag)
    }
}
