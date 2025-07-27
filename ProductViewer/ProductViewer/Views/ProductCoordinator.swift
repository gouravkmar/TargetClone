//
//  ProductCoordinator.swift
//  ProductViewer
//
//  Created by Gourav Kumar on 26/07/25.
//  Copyright © 2025 Target. All rights reserved.
//

import Foundation
import UIKit

protocol ProductCoordinatorProtocol {
    func didSelectProduct(product : Product)
}

final class ProductCoordinator {
    private let navigationController : UINavigationController
    
    let repository = ProductRepository() // can be injected if needed
    var productHomepage : ListViewController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        showHomePage()
    }
    
    func showHomePage(){
        let viewmodel = AllProductViewModel(productRepository: repository)
        productHomepage = ListViewController(viewModel: viewmodel, delegate: self)
        navigationController.pushViewController(productHomepage, animated: true)
    }
}

extension ProductCoordinator : ProductCoordinatorProtocol {
    
    func didSelectProduct(product: Product) {
        let viewModel = ProductDetailViewModel(productRepository: repository, product: product)
        let detailPage = ProductDetailViewController(viewModel: viewModel)
//        let backImage = UIImage(systemName: "chevron.left")?.withTintColor(.targetRed)
//        navigationController.navigationBar.backIndicatorImage = backImage
//        navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage
//        navigationController.navigationItem.backButtonTitle = ""
        navigationController.pushViewController(detailPage, animated: true)
    }
}
