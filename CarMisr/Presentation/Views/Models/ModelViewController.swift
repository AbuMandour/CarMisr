//
//  ModelViewController.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import UIKit

class ModelViewController: UIViewController {

    //MARK: - Constants
    let cellIdentifier = "modelViewCell"
    
    //MARK: - Properties
    @IBOutlet weak var modelsTableView: UITableView!
        
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Car Models"
        setupMakeTableView()
    }
    
    //MARK: - Internal Method
    private func setupMakeTableView(){
        modelsTableView.register(ModelTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}
