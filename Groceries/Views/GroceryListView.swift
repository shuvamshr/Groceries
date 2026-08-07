//
//  GroceryListView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 7/8/2026.
//

import SwiftUI

struct GroceryListView: View {
    
    @State private var products = [
        Product(title: "Tomato", description: "Please get the Roma kind, not the Gourmet. I'll go ham if I receive a Gourmet."),
        Product(title: "Orange", isPurchased: true),
        Product(title: "Pineapple", image: "pineapple")
    ]
    
    var body: some View {
        List {
            ForEach($products) { product in
                ProductView(product: product)
            }
        }
    }
}

#Preview {
    GroceryListView()
}
