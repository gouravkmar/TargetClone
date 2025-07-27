//
//  ProductDetail.swift
//  Target Clone
//
//  Created by Gourav Kumar on 26/07/25.
//

import Foundation

struct ProductDetail: Decodable {
    let id: Int
    let title: String
    let aisle: String
    let description: String
    let imageUrl: String
    let regularPrice: Price
    var salePrice: Price?
    let fulfillment: String
    let availability: String

    struct Price: Decodable {
        let amountInCents: Int
        let currencySymbol: String
        let displayString: String
    }
}
