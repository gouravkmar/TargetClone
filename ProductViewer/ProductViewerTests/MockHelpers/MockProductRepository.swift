//
//  MockProductRepository.swift
//  ProductViewerTests
//
//  Created by Gourav Kumar on 27/07/25.
//  Copyright © 2025 Target. All rights reserved.
//

import Foundation
@testable import ProductViewer

class MockRepository: ProductRepositoryProtocol {
    var shouldFail = false // fail the api calls when needed
    var onAddToCart: ((Product) -> Void)? // a callback to see if the product is added to the card or not
    func getTopDeals() async throws -> AllProducts {
        if shouldFail {
            throw NSError(domain: "MockError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch top deals"])
        }

        return AllProducts(products: [Product.mock, Product.mock])
    }

    func getProductDetails(product: Product) async throws -> ProductDetail {
        if shouldFail {
            throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch product details"])
        }

        return ProductDetail(
            id: product.id,
            title: product.title,
            aisle: product.aisle,
            description: product.description,
            imageUrl: product.imageUrl,
            regularPrice: ProductDetail.Price(
                amountInCents: product.regularPrice.amountInCents,
                currencySymbol: product.regularPrice.currencySymbol,
                displayString: product.regularPrice.displayString
            ),
            salePrice: product.salePrice.map {
                ProductDetail.Price(
                    amountInCents: $0.amountInCents,
                    currencySymbol: $0.currencySymbol,
                    displayString: $0.displayString
                )
            },
            fulfillment: product.fulfillment,
            availability: product.availability
        )
    }

    func addToCart(product: Product) {
        print("Mock: Added \(product.title) to cart")
        onAddToCart?(product)
    }
}
