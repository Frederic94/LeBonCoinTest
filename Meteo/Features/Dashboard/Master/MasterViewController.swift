//
//  MasterViewController.swift
//  Meteo
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import UIKit

import Meteo_Core

final class MasterViewController: UITableViewController {
    
    lazy var viewModel: MasterViewModel = {
        return MasterViewModel(useCase: DataFactory.provideDashboardUseCase())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.numberOfCells
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.getCell(at: indexPath)
        switch cell {
        case .forecast(let date, let forecast):
            let test = UITableViewCell()
            test.textLabel?.text = "\(date)"
            return test
        }
    }
}

// MARK: Setup
private extension MasterViewController {
    func setup() {
        setupVM()
    }
    
    func setupVM() {
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.fetch()
    }
}
