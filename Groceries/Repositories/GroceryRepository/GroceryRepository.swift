//
//  GroceryRepository.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation

/// Where the app gets its catalogue from. Views depend on this protocol rather
/// than a concrete type, so sample data and Supabase are interchangeable.
/// It's read-only: products and promotions are managed in Supabase itself.
protocol GroceryRepository {
    func fetchProducts() async throws -> [Product]
}
