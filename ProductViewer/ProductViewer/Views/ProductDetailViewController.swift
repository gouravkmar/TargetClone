// ProductDetailViewController.swift
// ProductViewer
//
// Created by Gourav Kumar on 26/07/25.

import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController {
    let viewModel: ProductDetailViewModel
    let detailView = ProductDetailView()

    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        view = detailView
        setupActions()
        bindViewModel()
        detailView.loadingIndicatorView.startAnimating()
    }

    private func setupActions() {
        detailView.addToCartButton.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
    }

    @objc private func addToCartAction() {
        viewModel.addToCart()
    }

    private func bindViewModel() {
        viewModel.onDataChange = { [weak self] in
            self?.populateProductDetails()
            self?.detailView.loadingIndicatorView.stopAnimating()
        }

        viewModel.onError = { [weak self] errorString in
            let alert = UIAlertController(
                title: "Error",
                message: errorString,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: { _ in
                self?.navigationController?.popToRootViewController(animated: true)
            }))
            self?.present(alert, animated: true, completion: nil)
            self?.detailView.loadingIndicatorView.stopAnimating()
        }
    }

    private func populateProductDetails() {
        if let product = viewModel.productDetail {
            detailView.configure(with: product)
        }
    }
}
