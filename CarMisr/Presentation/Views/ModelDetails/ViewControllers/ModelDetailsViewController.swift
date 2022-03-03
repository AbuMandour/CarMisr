//
//  ModelDetailsViewController.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ModelDetailsViewController: UIViewController , UITableViewDelegate {

    //MARK: - Constants
    let normalModelDetailsViewCell = "normalModelDetailsViewCell"
    let collectionModelDetailsViewCell = "collectionModelDetailsViewCell"
    
    //MARK: - Properties
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    private let modelDetailsViewModel: ModelDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMakeTableView()
        bind()
    }
    
    //MARK: - Initializer
    init(modelDetailsViewModel: ModelDetailsViewModel) {
        self.modelDetailsViewModel = modelDetailsViewModel
        super.init(nibName: "ModelDetailsViewController", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal Method
      private func setupMakeTableView(){
          detailsTableView.register(NormalModelDetailsTableViewCell.nib(), forCellReuseIdentifier: normalModelDetailsViewCell)
          detailsTableView.register(CollectionModelDetailsTableViewCell.nib(), forCellReuseIdentifier: collectionModelDetailsViewCell)
          detailsTableView.rx.setDelegate(self).disposed(by: disposeBag)
      }
      
      private func bind(){
          let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:))).take(1).mapToVoid().asDriverComplete()
          let input = ModelDetailsViewModel.Input(didAppear: viewDidAppear)
          let outup = modelDetailsViewModel.transform(input: input)
          outup.modelSpecs
              .bind(to: detailsTableView.rx.items){ [weak self] (tableView, row, modelSpecs) -> UITableViewCell in
                  guard let self = self else { return UITableViewCell()}
                  switch modelSpecs {
                  case .basic(let basicModelSpecs):
                        let cell = tableView.dequeueReusableCell(withIdentifier: self.normalModelDetailsViewCell,
                                                                 for: IndexPath.init(row: row, section: 0)) as! NormalModelDetailsTableViewCell
                      cell.configure(.init(basicModelSpecs: basicModelSpecs))
                      return cell
                  case .multi(let multiModelSpecs):
                        let cell = tableView.dequeueReusableCell(withIdentifier: self.collectionModelDetailsViewCell,
                                                                 for: IndexPath.init(row: row, section: 0)) as! CollectionModelDetailsTableViewCell
                      cell.configure(.init(multiModelSpecs: multiModelSpecs))
                      return cell
                  }
              }.disposed(by: disposeBag)
      }
}
