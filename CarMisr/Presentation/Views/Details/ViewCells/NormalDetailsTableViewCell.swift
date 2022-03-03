//
//  NormalModelDetailsTableViewCell.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class NormalDetailsTableViewCell: UITableViewCell , ViewCellDelegate {
    
    //MARK: - Properties
    typealias ViewModel = NormalDetailsCellViewModel
    private var disposeBag = DisposeBag()
    private var viewModel : ViewModel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    //MARK: - Overrides
    override func prepareForReuse() {
        keyLabel.text = nil
        valueLabel.text = nil
    }
    func configure(_ viewModel: NormalDetailsCellViewModel) {
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
        output.key
            .drive(keyLabel.rx.text)
            .disposed(by: disposeBag)
        output.value
            .drive(valueLabel.rx.text)
            .disposed(by: disposeBag)

    }

}
