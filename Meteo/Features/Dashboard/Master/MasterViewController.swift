//
//  MasterViewController.swift
//  Meteo
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import UIKit

import Meteo_Core
import Meteo_Components

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
        case .forecast(let model):
            return cellForecast(tableView: tableView, indexPath: indexPath, model: model)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoryboardScene.Dashboard.detail.instantiate()
        let forecast = viewModel.getForecast(at: indexPath)
        vc.viewModel = DetailViewModel(data: forecast)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Setup
private extension MasterViewController {
    func setup() {
        setupTableView()
        setupVM()
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(nib: ForecastCell.nib, withCellClass: ForecastCell.self)
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

private extension MasterViewController {
    func cellForecast(tableView: UITableView, indexPath: IndexPath, model: ForecastModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ForecastCell.self, for: indexPath)
        cell.configure(model: model)
        return cell
    }
}
