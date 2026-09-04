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
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: Grocery.self)
    }
}
