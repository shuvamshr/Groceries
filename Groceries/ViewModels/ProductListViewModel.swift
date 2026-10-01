//
//  ProductListViewModel.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation
import Observation

/// Owns the loaded catalogue and the grid's search and filter state. Shared by
/// both tabs, since My Locks needs the products to open a lock's product page.
@Observable
final class ProductListViewModel {
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var searchText = ""
    /// `nil` shows every product.
    var selectedFilter: ProductFilter? = .specials

    private let repository: any GroceryRepository

    init(repository: any GroceryRepository) {
        self.repository = repository
    }

    // MARK: - Derived Data

    /// Worked out from the data, so a new category in the database adds a pill.
    var categories: [String] {
        Set(products.map(\.category)).sorted()
    }

    var filteredProducts: [Product] {
        products.filter { matchesFilter($0) && matchesSearch($0) }
    }

    func product(for lock: PriceLock) -> Product? {
        products.first { $0.id == lock.productID }
    }

    // MARK: - Loading

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            products = try await repository.fetchProducts()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Filtering

private extension ProductListViewModel {
    func matchesFilter(_ product: Product) -> Bool {
        switch selectedFilter {
        case nil: true
        case .specials: product.activePromotion() != nil
        case .category(let category): product.category == category
        }
    }

    func matchesSearch(_ product: Product) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        return query.isEmpty
            || product.name.localizedStandardContains(query)
            || product.barcode.contains(query)
    }
}
