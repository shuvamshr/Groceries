//
//  GroceriesApp.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 7/8/2026.
//

import SwiftUI
import SwiftData

@main
struct GroceriesApp: App {
    // Swap for SupabaseGroceryRepository(projectURL:anonKey:) to use Supabase.
    private let repository: any GroceryRepository = LocalGroceryRepository()

    var body: some Scene {
        WindowGroup {
            ContentView(repository: repository)
        }
        .modelContainer(for: PriceLock.self)
    }
}
