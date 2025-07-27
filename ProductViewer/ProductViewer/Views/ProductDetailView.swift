//
//  ProductDetailView.swift
//  ProductViewer
//
//  Created by Gourav Kumar on 27/07/25.
//  Copyright © 2025 Target. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ProductDetailView: UIView {

    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.prepareForAutolayout()
        return imageView
    }()

    let titleLabel: UILabel = {
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

    let fulfillmentLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutolayout()
        label.textColor = .textLightGray
        label.font = .small
        return label
    }()

    let productDescriptionTitle: UILabel = {
        let label = UILabel()
        label.font = .largeBold
        label.numberOfLines = 1
        label.textColor = .black
        label.prepareForAutolayout()
        return label
    }()

    let productDescription: UILabel = {
        let label = UILabel()
        label.font = .medium
        label.numberOfLines = 0
        label.textColor = .grayMedium
        label.prepareForAutolayout()
        return label
    }()

    let addToCartButton: UIButton = {
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

    let loadingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.prepareForAutolayout()
        return indicator
    }()

    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [salePriceLabel, regularPriceLabel])
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()

    private lazy var itemShowcaseStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemImageView, titleLabel, priceStackView, fulfillmentLabel])
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 20
        stack.prepareForAutolayout()
        stack.backgroundColor = .systemBackground
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stack
    }()

    private lazy var productDetailsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [productDescriptionTitle, productDescription])
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 30
        stack.prepareForAutolayout()
        stack.backgroundColor = .systemBackground
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stack
    }()

    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemShowcaseStackView, productDetailsStackView])
        stack.alignment = .center
        stack.spacing = 10.0
        stack.distribution = .fill
        stack.axis = .vertical
        stack.prepareForAutolayout()
        return stack
    }()

    private lazy var scrollContainerView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.prepareForAutolayout()
        scrollView.addSubview(containerStackView)
        scrollView.backgroundColor = .background
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 10
        view.prepareForAutolayout()
        view.addAndPinSubview(addToCartButton, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .background
        addSubview(scrollContainerView)
        addSubview(buttonContainerView)
        addAndCenterSubview(loadingIndicatorView, constrainToEdges: true)
        loadingIndicatorView.startAnimating()

        NSLayoutConstraint.activate([
            scrollContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            scrollContainerView.widthAnchor.constraint(equalTo: widthAnchor),

            containerStackView.topAnchor.constraint(equalTo: scrollContainerView.contentLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollContainerView.contentLayoutGuide.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollContainerView.contentLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollContainerView.contentLayoutGuide.trailingAnchor),
            containerStackView.widthAnchor.constraint(equalTo: scrollContainerView.widthAnchor),
            containerStackView.heightAnchor.constraint(greaterThanOrEqualTo: scrollContainerView.heightAnchor),

            itemImageView.heightAnchor.constraint(equalToConstant: 400),
            itemShowcaseStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            productDetailsStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),

            buttonContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configure(with product: ProductDetail) {
        titleLabel.text = product.title
        salePriceLabel.text = product.salePrice?.displayString
        regularPriceLabel.text = "reg. \(product.regularPrice.displayString)"
        fulfillmentLabel.text = product.fulfillment
        productDescriptionTitle.text = "Product details"
        productDescription.text = product.description
        itemImageView.sd_setImage(with: URL(string: product.imageUrl))
    }
}
