//
//  MakerViewController.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MakeViewController: UIViewController, UITableViewDelegate {

    //MARK: - Constants
    let cellIdentifier = "makeViewCell"
    
    //MARK: - Properties
    @IBOutlet weak var makersTableView: UITableView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    private var makeViewModel: MakeViewModel
    private var disposeBag = DisposeBag()
    
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMakeTableView()
        bind()
        title = "Car Makes"
    }
    
    //MARK: - Initializer
    init(makeViewModel: MakeViewModel) {
        self.makeViewModel = makeViewModel
        super.init(nibName: "MakeViewController", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal Method
    private func setupMakeTableView(){
        makersTableView.register(MakeTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        makersTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bind(){
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:))).take(1).mapToVoid().asDriverComplete()
        let prefetchDataSource = makersTableView.rx.prefetchRows
        let input = MakeViewModel.Input(didAppear: viewDidAppear,
                                        makeSelected: makersTableView.rx.modelSelected(Make.self),
                                        prefetchRows: prefetchDataSource)
        let outup = makeViewModel.transform(input: input)
        outup.makes
            .bind(to: makersTableView.rx.items(cellIdentifier: cellIdentifier, cellType: MakeTableViewCell.self)) { (row, make, cell) in
                cell.configure(.init(model: make))
            }
            .disposed(by: disposeBag)
        outup.makes
            .map ({ $0.count <= 0})
            .distinctUntilChanged()
            .bind(to: makersTableView.rx.isEmpty(message: "No data"))
            .disposed(by: disposeBag)
        outup.isloading
            .observe(on: MainScheduler.instance)
            .map(!)
            .bind(to: mainActivityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        outup.isloadMore
            .observe(on: MainScheduler.instance)
            .map(!)
            .bind(to: loadMoreActivityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}
