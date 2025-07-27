//
//  DefaultProduct.swift
//  ProductViewerTests
//
//  Created by Gourav Kumar on 27/07/25.
//  Copyright © 2025 Target. All rights reserved.
//

import Foundation
@testable import ProductViewer
extension Product {
    static var mock: Product {
        return Product(
            id: 101,
            title: "Mock iPhone 15",
            aisle: "A3",
            description: "A mock description for testing purposes.",
            imageUrl: "https://via.placeholder.com/150",
            regularPrice: Product.Price(
                amountInCents: 109999,
                currencySymbol: "$",
                displayString: "$1,099.99"
            ),
            salePrice: Product.Price(
                amountInCents: 99999,
                currencySymbol: "$",
                displayString: "$999.99"
            ),
            fulfillment: "Pickup or delivery",
            availability: "In stock"
        )
    }
}
