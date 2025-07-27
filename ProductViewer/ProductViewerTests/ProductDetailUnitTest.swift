//
//  ProductDetailUnitTest.swift
//  ProductViewerTests
//
//  Created by Gourav Kumar on 27/07/25.
//  Copyright © 2025 Target. All rights reserved.
//

import XCTest
@testable import ProductViewer
final class ProductDetailUnitTest: XCTestCase {

    var mockRepository: MockRepository!
    var viewModel: ProductDetailViewModel!
    var mockProduct: Product!

    override func setUpWithError() throws {
        mockRepository = MockRepository()
        mockProduct = Product.mock
        viewModel = ProductDetailViewModel(productRepository: mockRepository, product: mockProduct)
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        viewModel = nil
        mockProduct = nil
    }

    func testFetchProductDetail_Success() throws {
        let expectation = expectation(description: "Product detail loaded")
        var fulfilled = false

        viewModel.onDataChange = {
            if !fulfilled {
                fulfilled = true
                expectation.fulfill()
            }
        }

        viewModel.fetchData(for: Product.mock)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(viewModel.productDetail)
        XCTAssertEqual(viewModel.productDetail?.id, mockProduct.id)
        XCTAssertEqual(viewModel.productDetail?.title, mockProduct.title)
    }

    func testFetchProductDetail_Failure() throws {
        mockRepository.shouldFail = true
        viewModel = ProductDetailViewModel(productRepository: mockRepository, product: mockProduct)

        let expectation = expectation(description: "Error triggered")
        var errorMessage: String?
        var didFulfill = false
        viewModel.onError = { error in
            errorMessage = error
            if !didFulfill {
                expectation.fulfill()
                didFulfill = true
            }
        }

        viewModel.fetchData(for: Product.mock)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(errorMessage)
    }

    func testAddToCart_InvokesRepository() throws {
        var didAddToCart = false
        
        mockRepository.onAddToCart = { product in
            didAddToCart = true
        }

        viewModel.addToCart()

        XCTAssertTrue(didAddToCart)
    }
}
