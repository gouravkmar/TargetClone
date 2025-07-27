//
//  ProductListCollectionViewCell.swift
//  ProductViewer
//
//  Created by Gourav Kumar on 26/07/25.
//  Copyright © 2025 Target. All rights reserved.
//

import UIKit
import SDWebImage

final class ProductListCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductListCollectionViewCell"
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForAutolayout()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let seperatorView : UIView = {
        let seperator = UIView()
        seperator.backgroundColor = .thinBorderGray
        seperator.prepareForAutolayout()
        return seperator
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutolayout()
        label.numberOfLines = 0
        label.font = UIFont.Details.copy2
        label.textColor = .grayDarkest
        return label
    }()
    
    let availabilityLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutolayout()
        label.font = .small
        label.textColor = .grayMedium
        return label
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [salePriceLabel, regularPriceLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .equalSpacing
        stack.prepareForAutolayout()
        return stack
    }()
    
    private lazy var rightStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceStack, fulfillmentLabel, titleLabel, availabilityLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.prepareForAutolayout()
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .background
        contentView.prepareForAutolayout()
        
        contentView.addSubview(productImage)
        contentView.addSubview(rightStack)
        contentView.addSubview(seperatorView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.8)
        ])
        
        NSLayoutConstraint.activate([
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            productImage.widthAnchor.constraint(equalToConstant: 120),
            productImage.heightAnchor.constraint(equalToConstant: 150),

            rightStack.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 20),
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rightStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
            
        ])
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.title
        salePriceLabel.text = product.salePrice?.displayString
        regularPriceLabel.text = "reg. \(product.regularPrice.displayString)"
        
        fulfillmentLabel.text = product.fulfillment
        availabilityLabel.attributedText = formattedAvailability(
            status: product.availability,
            aisle: product.aisle
        )
        
        productImage.sd_setImage(
            with: URL(string: product.imageUrl),
            placeholderImage: UIImage(named: "placeholder")
        )
    }
    
    private func formattedAvailability(status: String, aisle: String) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(NSAttributedString(string: status, attributes: [.foregroundColor: UIColor.targetTextGreen]))
        result.append(NSAttributedString(string: " in aisle \(aisle)", attributes: [.foregroundColor: UIColor.grayMedium]))
        return result
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
