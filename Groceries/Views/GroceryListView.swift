//
//  GroceryListView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 7/8/2026.
//

import SwiftUI

struct GroceryListView: View {
    
    @StateObject private var productViewModel = ProductViewModel()
    
    var body: some View {
        List {
            ForEach($productViewModel.products) { product in
                ProductView(product: product)
            }
        }
    }
}

#Preview {
    GroceryListView()
}
