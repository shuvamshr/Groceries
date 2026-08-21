//
//  GroceryListView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 7/8/2026.
//

import SwiftUI
import Lottie

struct GroceryListView: View {
    
    @StateObject private var productViewModel = ProductViewModel(repository: LocalProductRepository())
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach($productViewModel.products) { product in
                        ProductView(product: product)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add", systemImage: "plus") {
                            productViewModel.add(Product(title: "Banana"))
                        }
                    }
                }
                LottieView(animation: .named("confetti"))
                    .playing(loopMode: .loop)
                    .ignoresSafeArea()
            }
            
        }
    }
}

#Preview {
    GroceryListView()
}
