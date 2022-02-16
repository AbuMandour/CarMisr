//
//  MakeTableViewCell.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MakeTableViewCell: UITableViewCell, ViewCellDelegate {
        
    typealias ViewModel = MakeCellViewModel
    private var disposeBag = DisposeBag()
    private var viewModel : ViewModel!
    @IBOutlet weak var makeNameLabel: UILabel!
    
    override func prepareForReuse() {
        makeNameLabel.text = nil
    }
    
    
    func configure(_ viewModel: MakeCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    
    private func bindViewModel() {
        let layoutSubViews = rx.sentMessage(#selector(UITableViewCell.layoutSubviews))
            .take(1)
            .map{ _ in }
            .asDriver(onErrorRecover: {(error) in return Driver.empty() })
        let input = ViewModel.Input(tigger: layoutSubViews)
        
        let output = viewModel.transform(input: input)
        output.name
            .drive(makeNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
