//
//  ReactiveExtension.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 17/02/2022.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    func isEmpty(message: String) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setNoDataPlaceholder(message)
            } else {
                tableView.removeNoDataPlaceholder()
            }
        }
    }
}
