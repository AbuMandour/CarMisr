//
//  CollectionModelDetailsTableViewCellTableViewCell.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import UIKit
import RxCocoa
import RxSwift

class CollectionDetailsTableViewCell: UITableViewCell, ViewCellDelegate , UICollectionViewDelegate {
    
    //MARK: - Constants
    let cellIdentifier = "ColorCollectionViewCell"
    
    //MARK: - Properties
    typealias ViewModel = CollectionDetailsCellViewModel
    private var disposeBag = DisposeBag()
    private var viewModel : ViewModel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var keyLabel: UILabel!

    //MARK: - Overrides
    override func prepareForReuse() {
        keyLabel.text = nil
    }
    override func awakeFromNib() {
        setupColorCollectionView()
    }
    func configure(_ viewModel: CollectionDetailsCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    //MARK: - Internal Method
    private func setupColorCollectionView(){
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)        
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
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
        output.values
            .bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ColorCollectionViewCell.self)){ (row, color, cell) in
                cell.configure(colorHex: color)
            }.disposed(by: disposeBag)

    }
}

extension CollectionDetailsTableViewCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
}
