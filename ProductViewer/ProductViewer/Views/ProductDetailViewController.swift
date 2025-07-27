//
//  ProductDetailViewController.swift
//  ProductViewer
//
//  Created by Gourav Kumar on 26/07/25.
//

import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController {
    let viewModel : ProductDetailViewModel
    
    let itemImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.prepareForAutolayout()
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .largeBold
        label.numberOfLines = 0
        label.textColor = .black
        label.prepareForAutolayout()
        return label
    }()
    
    let salePriceLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutolayout()
        label.textColor = .targetRed
        label.font = .largeBold
        return label
    }()
    
    let regularPriceLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutolayout()
        label.textColor = .grayMedium
        label.font = .small
        return label
    }()

    let loadingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.prepareForAutolayout()
        return indicator
    }()
    let fulfillmentLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutolayout()
        label.textColor = .textLightGray
        label.font = .small
        return label
    }()
    let productDescriptionTitle : UILabel = {
        let label = UILabel()
        label.font = .largeBold
        label.numberOfLines = 1
        label.textColor = .black
        label.prepareForAutolayout()
        return label
    }()
    let productDescription : UILabel = {
        let label = UILabel()
        label.font = .medium
        label.numberOfLines = 0
        label.textColor = .grayMedium
        label.prepareForAutolayout()
        return label
    }()
    private lazy var priceStackView : UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [salePriceLabel,regularPriceLabel])
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        stackview.spacing = 10
        stackview.axis = .horizontal
        return stackview
    }()
    private lazy var itemShowcaseStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemImageView,titleLabel,priceStackView,fulfillmentLabel])
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.prepareForAutolayout()
        stackView.backgroundColor = .background
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stackView
    }()
    @objc private let addToCartButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .targetRed
        button.titleLabel?.textColor = .white
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .selected)
        button.setTitle("Add to cart", for: .normal)
        button.layer.cornerRadius = 5
        button.prepareForAutolayout()
        return button
    }()
    private lazy var buttonContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 10
        view.prepareForAutolayout()
        view.addAndPinSubview(addToCartButton, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        return view
    }()
    
    private lazy var productDetailsStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productDescriptionTitle,productDescription])
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.prepareForAutolayout()
        stackView.backgroundColor = .background
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stackView
    }()
    private lazy var containerStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemShowcaseStackView,productDetailsStackView])
        stackView.alignment = .center
        stackView.spacing = 10.0
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.prepareForAutolayout()
        return stackView
    }()
    private lazy var scrollContainerView : UIScrollView  = {
        let scrollView = UIScrollView()
        scrollView.prepareForAutolayout()
        scrollView.addSubview(containerStackView)
        scrollView.backgroundColor = .grayMedium
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()
    
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
        setupViews()
        setupColors()
        setupConstraints()
        setupActions()
        viewModel.onDataChange = { [weak self] in
            self?.getProductDetailData()
            self?.loadingIndicatorView.stopAnimating()
        }
        viewModel.onError = {[weak self] errorString in
            let alert = UIAlertController(
                title: "Error",
                message: errorString,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: {_ in
                self?.navigationController?.popToRootViewController(animated: true)
            }))
            self?.present(alert, animated: true, completion: nil)
            self?.loadingIndicatorView.stopAnimating()
            
        }
       
    }
    func setupActions(){
        addToCartButton.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
    }
    @objc func addToCartAction(){
        viewModel.addToCart()
    }
    
    
    func setupViews(){
        view.addSubview(scrollContainerView)
        view.addSubview(buttonContainerView)
        view.addAndCenterSubview(loadingIndicatorView, constrainToEdges: true)
        loadingIndicatorView.startAnimating()
    }
    
    func setupColors(){
        self.view.backgroundColor = .background
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            scrollContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: scrollContainerView.contentLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollContainerView.contentLayoutGuide.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollContainerView.contentLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollContainerView.contentLayoutGuide.trailingAnchor),
            containerStackView.widthAnchor.constraint(equalTo: scrollContainerView.widthAnchor),
            containerStackView.heightAnchor.constraint(greaterThanOrEqualTo: scrollContainerView.heightAnchor),
            itemImageView.heightAnchor.constraint(equalToConstant: 400),

            itemShowcaseStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            productDetailsStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    func getProductDetailData() {
        guard let product = viewModel.productDetail else {return}
        titleLabel.text = product.title
        salePriceLabel.text = product.salePrice?.displayString
        regularPriceLabel.text = "reg. \(product.regularPrice.displayString)"
        fulfillmentLabel.text = product.fulfillment
        productDescriptionTitle.text = "Product details"
        productDescription.text = product.description
        itemImageView.sd_setImage(with: URL(string: product.imageUrl))
    }

}
