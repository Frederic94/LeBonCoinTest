//
//  DetailViewController.swift
//  Meteo
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import UIKit

import Meteo_Components

final class DetailViewController: UIViewController {
    
    enum Constant {
        static let itemSpacing: CGFloat = 16.0
        static let lineSpacing: CGFloat = 16.0
    }
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(nib: ForecastByHourCell.nib, forCellWithClass: ForecastByHourCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet private weak var dayNameLabel: UILabel!

    lazy var viewModel: DetailViewModel = {
        return DetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension DetailViewController {
    func setup() {
        setupLayout()
        dayNameLabel.text = viewModel.dayName
        
    }
    
    func setupLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }

}

extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.cells[indexPath.row]
        return cellForecast(collectionView: collectionView, indexPath: indexPath, model: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 180)
    }
}

private extension DetailViewController {
    func cellForecast(collectionView: UICollectionView, indexPath: IndexPath, model: ForecastByHourModel) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ForecastByHourCell.self, for: indexPath)
        cell.configure(model: model)
        return cell
    }
}
