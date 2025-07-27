//
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    let viewModel : AllProductViewModel
    var itemTapDelegate : ProductCoordinatorProtocol?
    init(viewModel: AllProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(viewModel : AllProductViewModel, delegate : ProductCoordinatorProtocol){
        self.init(viewModel: viewModel)
        self.itemTapDelegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var layout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(170)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        
        item.edgeSpacing = .init(
            leading: nil,
            top: .fixed(8),
            trailing: nil,
            bottom: .fixed(8)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(170)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(
            group: group
        )
        
        let layout = UICollectionViewCompositionalLayout(
            section: section
        )
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.backgroundColor = UIColor.background
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ProductListCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductListCollectionViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        setupNavBar()
        setupViews()
        setupViewModel()
        
    }
    func setupViews(){
        collectionView.contentInset = UIEdgeInsets(
            top: 20.0,
            left: 0.0,
            bottom: 0.0,
            right: 0.0
        )
        title = "List"
        
        view.addAndPinSubview(collectionView)
    }
    func setupViewModel(){
        
        viewModel.onDataChange = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorString in
            let alert = UIAlertController(
                title: "Error",
                message: errorString,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            self?.present(alert, animated: true, completion: nil)
        }
    }
    func setupNavBar(){
        let backImage = UIImage(systemName: "arrow.backward")
        navigationController?.navigationBar.tintColor = .targetRed
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backButtonTitle = ""
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let products = viewModel.productData?.products , products.indices.contains(indexPath.row)
        else {
            return
        }
        
        let productListItem = products[indexPath.row]
        self.itemTapDelegate?.didSelectProduct(product: productListItem)
        
        
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.productData?.products.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let products = viewModel.productData?.products,
                products.indices.contains(indexPath.row),
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductListCollectionViewCell.reuseIdentifier,
                for: indexPath
              ) as? ProductListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}

