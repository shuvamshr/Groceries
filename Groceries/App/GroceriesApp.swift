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

    private let repository: any GroceryRepository = SupabaseGroceryRepository(projectURL: URL(string: "https://omogbyofwrznlduxihuj.supabase.co")!, publishableKey: "sb_publishable_qA3Z2JXbPAcbiL8x5asliw_u-nEdHpI")

    
    var body: some Scene {
        WindowGroup {
            ContentView(repository: repository)
        }
        .modelContainer(for: PriceLock.self)
    }
}
