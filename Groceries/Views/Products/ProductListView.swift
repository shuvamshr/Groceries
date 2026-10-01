//
//  ProductListView.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftData
import SwiftUI

struct ProductListView: View {
    @Bindable var viewModel: ProductListViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                CategoryPills(categories: viewModel.categories, selection: $viewModel.selectedFilter)
                    .padding(.vertical, 8)

                staggeredGrid
            }
            .background(Color(.systemGroupedBackground))
            .overlay { emptyState }
            .navigationTitle("Products")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .searchable(text: $viewModel.searchText, prompt: "Search products")
            .refreshable { await viewModel.loadProducts() }
        }
    }
}

// MARK: - Subviews

private extension ProductListView {
    /// Two independent columns, so each card keeps its own height
    /// (`LazyVGrid` would make every card in a row the same height).
    var staggeredGrid: some View {
        HStack(alignment: .top, spacing: 16) {
            column(0)
            column(1)
        }
        .padding([.horizontal, .bottom])
    }

    /// Products alternate between the columns: left, right, left, right…
    func column(_ index: Int) -> some View {
        let products = viewModel.filteredProducts.enumerated()
            .filter { $0.offset % 2 == index }
            .map(\.element)

        return LazyVStack(spacing: 16) {
            ForEach(products) { product in
                NavigationLink(value: product) {
                    ProductCard(product: product)
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    var emptyState: some View {
        if viewModel.products.isEmpty {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView("Couldn't Load Products", systemImage: "wifi.exclamationmark", description: Text(errorMessage))
            }
        } else if viewModel.filteredProducts.isEmpty {
            if viewModel.searchText.isEmpty {
                ContentUnavailableView("No Products", systemImage: "basket")
            } else {
                ContentUnavailableView.search(text: viewModel.searchText)
            }
        }
    }
}

#Preview {
    ProductListView(viewModel: ProductListViewModel(repository: LocalGroceryRepository()))
        .modelContainer(for: PriceLock.self, inMemory: true)
}
