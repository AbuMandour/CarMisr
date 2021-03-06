//
//  ModelDetailsViewController.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController , UITableViewDelegate {

    //MARK: - Constants
    let normalDetailsViewCell = "normalModelDetailsViewCell"
    let collectionDetailsViewCell = "collectionModelDetailsViewCell"
    
    //MARK: - Properties
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    private let detailsViewModel: DetailsViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMakeTableView()
        bind()
    }
    
    //MARK: - Initializer
    init(detailsViewModel: DetailsViewModel) {
        self.detailsViewModel = detailsViewModel
        super.init(nibName: "DetailsViewController", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal Method
      private func setupMakeTableView(){
          detailsTableView.register(NormalDetailsTableViewCell.nib(), forCellReuseIdentifier: normalDetailsViewCell)
          detailsTableView.register(CollectionDetailsTableViewCell.nib(), forCellReuseIdentifier: collectionDetailsViewCell)
          detailsTableView.rx.setDelegate(self).disposed(by: disposeBag)
      }
      
      private func bind(){
          let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:))).take(1).mapToVoid().asDriverComplete()
          let input = DetailsViewModel.Input(didAppear: viewDidAppear)
          let outup = detailsViewModel.transform(input: input)
          outup.modelSpecs
              .bind(to: detailsTableView.rx.items){ [weak self] (tableView, row, modelSpecs) -> UITableViewCell in
                  guard let self = self else { return UITableViewCell()}
                  switch modelSpecs {
                  case .basic(let basicModelSpecs):
                        let cell = tableView.dequeueReusableCell(withIdentifier: self.normalDetailsViewCell,
                                                                 for: IndexPath.init(row: row, section: 0)) as! NormalDetailsTableViewCell
                      cell.configure(.init(basicModelSpecs: basicModelSpecs))
                      return cell
                  case .multi(let multiModelSpecs):
                        let cell = tableView.dequeueReusableCell(withIdentifier: self.collectionDetailsViewCell,
                                                                 for: IndexPath.init(row: row, section: 0)) as! CollectionDetailsTableViewCell
                      cell.configure(.init(multiModelSpecs: multiModelSpecs))
                      return cell
                  }
              }.disposed(by: disposeBag)
      }
}
