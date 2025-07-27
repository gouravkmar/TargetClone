//
//  ProductDetailViewModel.swift
//  Target Clone
//
//  Created by Gourav Kumar on 26/07/25.
//

import Foundation


class ProductDetailViewModel {
    
    let productRepository : ProductRepositoryProtocol
    private(set) var productDetail : ProductDetail?
    private(set) var selectedProduct : Product
    init(productRepository: ProductRepositoryProtocol, product : Product) {
        self.productRepository = productRepository
        self.selectedProduct = product
        fetchData(for: product)
    }
    
    var onDataChange : (()-> Void)?
    var onError : ((String)->Void)?
    
    func fetchData(for product : Product){
        Task {
            do {
                var productDetail = try await self.productRepository.getProductDetails(product: product)
                if productDetail.salePrice == nil {
                    productDetail.salePrice = productDetail.regularPrice
                }// defaulting to regular price in case the sale price is missing in the API response as i have witnessed
                self.productDetail = productDetail
                await MainActor.run{
                    onDataChange?()
                }
            }catch {
                let errorDesc = error.localizedDescription
                await MainActor.run{
                    onError?("Error occured: \(errorDesc)")
                }
                
            }
        }
    }
    
    func addToCart() {
        productRepository.addToCart(product: selectedProduct)
    }
   
    
}
