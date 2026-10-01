//
//  ContentView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var viewModel: ProductListViewModel

    init(repository: any GroceryRepository) {
        _viewModel = State(initialValue: ProductListViewModel(repository: repository))
    }

    var body: some View {
        TabView {
            Tab("Products", systemImage: "carrot.fill") {
                ProductListView(viewModel: viewModel)
            }
            Tab("My Locks", systemImage: "lock") {
                PriceLockListView(viewModel: viewModel)
            }
        }
        .task { await viewModel.loadProducts() }
    }
}

#Preview {
    ContentView(repository: LocalGroceryRepository())
        .modelContainer(for: PriceLock.self, inMemory: true)
}
