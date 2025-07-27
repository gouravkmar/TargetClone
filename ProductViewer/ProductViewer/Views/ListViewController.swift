//
//  ListViewController.swift
//  ProductViewer
//
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {

    private let viewModel: AllProductViewModel
    private let listView = ProductListView()
    private var itemTapDelegate: ProductCoordinatorProtocol?

    init(viewModel: AllProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(viewModel: AllProductViewModel, delegate: ProductCoordinatorProtocol) {
        self.init(viewModel: viewModel)
        self.itemTapDelegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
        view = listView
        setupNavBar()
        setupBindings()
        listView.collectionView.dataSource = self
        listView.collectionView.delegate = self
    }

    private func setupBindings() {
        viewModel.onDataChange = { [weak self] in
            self?.listView.collectionView.reloadData()
        }

        viewModel.onError = { [weak self] errorString in
            let alert = UIAlertController(
                title: "Error",
                message: errorString,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self?.present(alert, animated: true, completion: nil)
        }
    }

    private func setupNavBar() {
        let backImage = UIImage(systemName: "arrow.backward")
        navigationController?.navigationBar.tintColor = .targetRed
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backButtonTitle = ""
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let products = viewModel.productData?.products,
              products.indices.contains(indexPath.row) else {
            return
        }
        let productListItem = products[indexPath.row]
        itemTapDelegate?.didSelectProduct(product: productListItem)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productData?.products.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let products = viewModel.productData?.products,
              products.indices.contains(indexPath.row),
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductListCollectionViewCell.reuseIdentifier,
                for: indexPath
              ) as? ProductListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: products[indexPath.row])
        return cell
    }
}
