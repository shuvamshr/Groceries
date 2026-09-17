//
//  GroceryListView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 7/8/2026.
//

import SwiftUI
import SwiftData
import Lottie

struct GroceryListView: View {
    
    @Bindable var grocery: Grocery
    @EnvironmentObject private var productViewModel: ProductViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            Section {
                if grocery.items.isEmpty {
                    ContentUnavailableView("New Items Yet", systemImage: "carrot.fill", description: Text("Add product from list below to get started"))
                } else {
                    ForEach(grocery.items) { item in
                        GroceryItemView(item: item)
                    }
                    .onDelete(perform: deleteItems)
                }

            } header: {
                Text("My List")
            }
            Section {
                ForEach($productViewModel.products) { product in
                    ProductView(product: product, grocery: grocery)
                }
            } header: {
                Text("Available Products")
            }
        }
        .toolbar {
            
        }
        .navigationTitle(grocery.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar)
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(grocery.items[index])
        }
        grocery.items.remove(atOffsets: offsets)
    }
}

