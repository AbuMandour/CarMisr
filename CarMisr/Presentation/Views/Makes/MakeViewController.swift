//
//  MakerViewController.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit

class MakeViewController: UIViewController {

    //MARK: - Constants
    let cellIdentifier = "makeViewCell"
    
    //MARK: - Properties
    @IBOutlet weak var makersTableView: UITableView!
    
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Car Makers"
        setupMakeTableView()
    }
    
    //MARK: - Internal Method
    private func setupMakeTableView(){
        makersTableView.register(MakeTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}
