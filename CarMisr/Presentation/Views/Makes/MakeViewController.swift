//
//  MakerViewController.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit

class MakeViewController: UIViewController {

    let cellIdentifier = "makeViewCell"
    
    @IBOutlet weak var makersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Car Makers"
        setupMakeTableView()
    }
    
    func setupMakeTableView(){
        makersTableView.register(MakeTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}
