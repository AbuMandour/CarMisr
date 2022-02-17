//
//  ModelTableViewCell.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ModelTableViewCell: UITableViewCell , ViewCellDelegate {

    //MARK: - Properties
    typealias ViewModel = ModelCellViewModel    
    private var viewModel : ViewModel!
    private var disposeBag = DisposeBag()
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var modelImageView: UIImageView!
        
    //MARK: - Overrides
    override func prepareForReuse() {
        modelImageView.image = nil
        modelNameLabel.text = nil
    }
    func configure(_ viewModel: ModelCellViewModel) {
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
            .drive(modelNameLabel.rx.text)
            .disposed(by: disposeBag)
        output.imageUrl
            .drive(onNext: { [weak self] (url) in
                guard let self = self else {return}
                self.modelImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
    }
    
}
