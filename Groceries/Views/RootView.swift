//
//  RootView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 28/8/2026.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var productViewModel = ProductViewModel(repository: LocalProductRepository())
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                GroceryListView()
            }
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
        }
        .environmentObject(productViewModel)
    }
}

#Preview {
    RootView()
}
