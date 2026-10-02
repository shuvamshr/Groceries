//
//  SupabaseGroceryRepository.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation
import Supabase

struct SupabaseGroceryRepository: GroceryRepository {
    
    private let client: SupabaseClient
    
    init(projectURL: URL, publishableKey: String) {
        self.client = SupabaseClient(supabaseURL: projectURL, supabaseKey: publishableKey)
    }
    
    func fetchProducts() async throws -> [Product] {
        try await client
            .from("products")
            .select("*, promotions(*), price_history(*)")
            .order("name")
            .execute()
            .value
    }
}
