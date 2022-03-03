//
//  StyleCellViewModel.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 02/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

class StyleTableViewCell: UITableViewCell, ViewCellDelegate {
        
    //MARK: - Properties
    typealias ViewModel = StyleCellViewModel
    private var disposeBag = DisposeBag()
    private var viewModel : ViewModel!
    
    @IBOutlet weak var styleNameLabel: UILabel!
    //MARK: - Overrides
    override func prepareForReuse() {
        styleNameLabel.text = nil
    }
    
    func configure(_ viewModel: StyleCellViewModel) {
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
            .drive(styleNameLabel.rx.text)
            .disposed(by: disposeBag)        
    }
}
