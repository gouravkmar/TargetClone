//
//  AllProductsUnitTest.swift
//  ProductViewerTests
//
//  Created by Gourav Kumar on 27/07/25.
//  Copyright © 2025 Target. All rights reserved.
//

import XCTest
@testable import ProductViewer

final class AllProductsUnitTest: XCTestCase {

    var mockRepository : ProductRepositoryProtocol!
    var allProductsViewModel : AllProductViewModel!
    override func setUpWithError() throws {
        mockRepository = MockRepository()
        allProductsViewModel = AllProductViewModel(productRepository: mockRepository)
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        allProductsViewModel = nil
    }

    func testFetchResults() throws {
        let expectation = expectation(description: "products loaded")
        var onDataChangeCalled = false
        var fulfilled = false
        
        allProductsViewModel.onDataChange = {
            onDataChangeCalled = true
            if !fulfilled {
                fulfilled = true
                expectation.fulfill()
            }
        }

        allProductsViewModel.fetchData()
        
        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(onDataChangeCalled)
        XCTAssertEqual(allProductsViewModel.productData?.products.count, 2)
    }
    func testErrorFallbackOnFailure() throws {
        let expectation = expectation(description: "products loaded")
        let mockRepo = MockRepository()
        mockRepo.shouldFail = true
        let viewmodel = AllProductViewModel(productRepository: mockRepo)
        var expectationFulfilled = false
        viewmodel.onError = { error in
            if !expectationFulfilled {
                expectationFulfilled = true
                expectation.fulfill()
                XCTAssertNotNil(error)
            }
        }
        wait(for: [expectation], timeout: 1)
        viewmodel.fetchData()
        XCTAssert(expectationFulfilled)
    }
    func testInitialProductList(){
        XCTAssertNil(allProductsViewModel.productData?.products)
    }
    func testViewModelRepositoryInjectedCorrectly() {
        XCTAssertNotNil(allProductsViewModel)
        XCTAssertNotNil(mockRepository)
    }
    


}



