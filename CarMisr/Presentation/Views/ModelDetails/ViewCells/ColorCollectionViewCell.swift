//
//  ColorCollectionViewCell.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ColorCollectionViewCell: UICollectionViewCell , ViewCellDelegate {
    
    //MARK: - Properties
    typealias ViewModel = ColorCellViewModel
    private var disposeBag = DisposeBag()
    private var viewModel : ViewModel!
    @IBOutlet weak var colorView: UIView!

    //MARK: - Overrides

    func configure(_ viewModel: ColorCellViewModel) {
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
        output.color
            .drive(colorView.rx.backgroundColor)
            .disposed(by: disposeBag)

    }
}
