//
//  MasterViewController.swift
//  Meteo
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import UIKit
import CoreLocation

import Meteo_Core
import Meteo_Components

final class MasterViewController: UITableViewController {
    
    private let locationManager = CLLocationManager()
    
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
        navigateToDetail(index: indexPath.row)
    }
}

// MARK: Setup
private extension MasterViewController {
    func setup() {
        setupLocation()
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
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self?.navigateToDetail(index: 0)
                }
            }
        }
    }
    
    func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

private extension MasterViewController {
    func cellForecast(tableView: UITableView, indexPath: IndexPath, model: ForecastModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ForecastCell.self, for: indexPath)
        cell.configure(model: model)
        return cell
    }
    
    func navigateToDetail(index: Int) {
        let vc = StoryboardScene.Dashboard.detail.instantiate()
        let forecast = viewModel.getForecast(at: index)
        vc.viewModel.forecastByDay = forecast
        splitViewController?.showDetailViewController(vc, sender: nil)
    }
}

extension MasterViewController: UISplitViewControllerDelegate { }

extension MasterViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            viewModel.fetch(location: location)
            viewModel.fetchCityAndCountry(from: location) { [weak self] (city, _) in
                self?.title = city
            }
        }
    }
}
