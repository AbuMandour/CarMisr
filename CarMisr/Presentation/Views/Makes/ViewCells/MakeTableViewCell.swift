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
        
    //MARK: - Properties
    typealias ViewModel = MakeCellViewModel
    private var disposeBag = DisposeBag()
    private var viewModel : ViewModel!
    @IBOutlet weak var makeNameLabel: UILabel!
    
    //MARK: - Overrides
    override func prepareForReuse() {
        makeNameLabel.text = nil
    }        
    func configure(_ viewModel: MakeCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    //MARK: - Internal Method
    private func bindViewModel() {
        let layoutSubViews = rx.sentMessage(#selector(UITableViewCell.layoutSubviews))
            .take(1)
            .mapToVoid()
            .asDriverComplete()
        let input = ViewModel.Input(tigger: layoutSubViews)
        
        let output = viewModel.transform(input: input)
        output.name
            .drive(makeNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
