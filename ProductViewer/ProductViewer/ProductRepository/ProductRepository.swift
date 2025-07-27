//
//  ProductRepository.swift
//  Target Clone
//
//  Created by Gourav Kumar on 26/07/25.
//

import Foundation
enum RepositoryError : Error {
    case invalidData
    case decodingError(String)
}
protocol ProductRepositoryProtocol {
    func getTopDeals() async throws -> AllProducts
    func getProductDetails(product : Product) async throws -> ProductDetail
    func addToCart(product : Product)
}


class ProductRepository : ProductRepositoryProtocol {
    
    func addToCart(product: Product) {
        // implement this in future versions
    }
    
    
    func getTopDeals() async throws -> AllProducts {
        let networkRequest = NetworkRequestBuilder()
            .setScheme(TargetAPIConfig.scheme)
            .setHost(TargetAPIConfig.host)
            .setMethod(.get)
            .setPath(TargetAPIConfig.Path.basePath)
            .build()
        let (data,_) = try await NetworkManager.shared.makeAPIRequest(networkRequest: networkRequest)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let dealData = try decoder.decode(AllProducts.self, from: data)
            return dealData
        }catch {
            throw RepositoryError.decodingError(error.localizedDescription)
        }
    }
    
    func getProductDetails(product: Product) async throws -> ProductDetail {
        let networkRequest = NetworkRequestBuilder()
            .setScheme(TargetAPIConfig.scheme)
            .setHost(TargetAPIConfig.host)
            .setMethod(.get)
            .setPath(TargetAPIConfig.Path.basePath)
            .appendPathComponent(String(product.id)) // check if this is correct 
            .build()
        
        let (data,_) = try await NetworkManager.shared.makeAPIRequest(networkRequest: networkRequest)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let productDetails = try decoder.decode(ProductDetail.self, from: data)
            return productDetails
        }catch {
            throw RepositoryError.decodingError(error.localizedDescription)
        }
    }
    
    
    
    
}
