//
//  GroceriesTests.swift
//  GroceriesTests
//
//  Created by Shuvam Shrestha on 28/8/2026.
//

import Foundation
import Testing
@testable import Groceries

import XCTest

struct GroceriesTests {
    
    @Test func init_loadsProducts() {
        
        let repository = LocalProductRepository()
        
        #expect(!repository.products.isEmpty)
        
    }

    @Test func add_addProductWorks() {
        
        let repository = LocalProductRepository()
        
        let totalBeforeAdd = repository.products.count
        
        let sampleProduct = Product(title: "Banana")
        
        repository.add(sampleProduct)
        
        #expect(repository.products.count > totalBeforeAdd)
    }
    
    @Test func add_duplicateProductIncreasesQuantity() {
            let repository = LocalProductRepository()
            let viewModel = ProductViewModel(repository: repository)
            
            // Clear any existing products to start fresh for the test
            viewModel.products.forEach { viewModel.delete($0) }
            
            let initialProduct = Product(title: "Apple", description: "Fresh red apples", quantity: 2)
            viewModel.add(initialProduct)
            
            #expect(viewModel.products.count == 1)
            #expect(viewModel.products.first?.quantity == 2)
            
            // Add duplicate product with same details (different ID generated automatically)
            let duplicateProduct = Product(title: "Apple", description: "Fresh red apples", quantity: 3)
            viewModel.add(duplicateProduct)
            
            #expect(viewModel.products.count == 1)
            #expect(viewModel.products.first?.quantity == 5)
        }

}



//class LocalProductRepositoryTests: XCTestCase {
//    func add_addProductWorksXC() {
//        let repository = LocalProductRepository()
//        
//        let totalBeforeAdd = repository.products.count
//        
//        let sampleProduct = Product(title: "Banana")
//        
//        repository.add(sampleProduct)
//        
//        XCTAssertTrue(repository.products.count > totalBeforeAdd)
//    }
//}

