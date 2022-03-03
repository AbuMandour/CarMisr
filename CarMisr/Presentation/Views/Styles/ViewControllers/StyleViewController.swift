//
//  StyleViewController.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 02/03/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlertViewable

class StyleViewController: UIViewController, UITableViewDelegate, RxAlertViewable {

    //MARK: - Constants
    let cellIdentifier = "styleViewCell"
    
    //MARK: - Properties
    @IBOutlet weak var stylesTableView: UITableView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    private var styleViewModel: StylesViewModel
    private var disposeBag = DisposeBag()
    
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyleTableView()
        bind()
        title = "Model Styles"
    }
    
    //MARK: - Initializer
    init(styleViewModel: StylesViewModel) {
        self.styleViewModel = styleViewModel
        super.init(nibName: "StyleViewController", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal Method
    private func setupStyleTableView(){
        stylesTableView.register(StyleTableViewCell.nib(), forCellReuseIdentifier: cellIdentifier)
        stylesTableView.rx.setDelegate(self).disposed(by: disposeBag)
        stylesTableView.refreshControl = refreshControl
        stylesTableView.rowHeight = 88
    }
    
    private func bind(){        
        stylesTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return  }
                self.stylesTableView.deselectRow(at: indexPath, animated: false) }
            .disposed(by: disposeBag)
                
        let refreshTable = refreshControl.rx.controlEvent(.valueChanged).mapToVoid().asDriverComplete()
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:))).take(1).mapToVoid().asDriverComplete()
        let prefetchDataSource = stylesTableView.rx.prefetchRows
        let input = StylesViewModel.Input(didAppear: viewDidAppear,
                                        refresh: refreshTable,
                                        styleSelected: stylesTableView.rx.modelSelected(Style.self),
                                        prefetchRows: prefetchDataSource)
        
        let outup = styleViewModel.transform(input: input)
        outup.styles
            .bind(to: stylesTableView.rx.items(cellIdentifier: cellIdentifier, cellType: StyleTableViewCell.self)) { (row, style, cell) in
                cell.configure(.init(style: style))
            }
            .disposed(by: disposeBag)
        outup.styles
            .map ({ $0.count <= 0})
            .distinctUntilChanged()
            .bind(to: stylesTableView.rx.isEmpty(message: Defaults.noDataMessage))
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
