//
//  AllProductViewModel.swift
//  Target Clone
//
//  Created by Gourav Kumar on 26/07/25.
//

import Foundation


class AllProductViewModel {
    
    let productRepository : ProductRepositoryProtocol
    private(set) var productData : AllProducts?
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
        fetchData()
    }
    
    var onDataChange : (()-> Void)?
    var onError : ((String)->Void)?
    
    func fetchData(){
        Task {
            do {
                var allProducts = try await productRepository.getTopDeals()
                for i in 0..<allProducts.products.count {
                    if allProducts.products[i].salePrice == nil {
                        allProducts.products[i].salePrice = allProducts.products[i].regularPrice
                    }
                }// setting regular price as sale price if the price is missing in the response 
                productData = allProducts
                
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
   
//    func fetchData(for page : Int){ // extendible for pagination in later versions
//
//    }
    
}

