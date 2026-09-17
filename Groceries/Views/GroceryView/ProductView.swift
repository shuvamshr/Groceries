//
//  ProductView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 7/8/2026.
//

import SwiftUI
import Lottie
import SwiftData

struct ProductView: View {
    
    @Binding var product: Product
    @Bindable var grocery: Grocery
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: product.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 42, height: 42)
            .clipShape(RoundedRectangle(cornerRadius: 8))
               
            VStack(alignment: .leading) {
                Text(product.title)
                Text("Price: \(product.price.formatted(.currency(code: "AUD")))")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.secondary)
                   
            }
            Spacer()
            Button {
                addNewItem()
            } label: {
               
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color.accentColor)
           
            }
        }
       
    }
    
    private func addNewItem() {
        if let existingItem = grocery.items.first(where: { $0.title == product.title }) {
            existingItem.quantity += 1
        } else {
            let newItem = GroceryItem(title: product.title, imageURL: product.imageURL, isPurchased: false, quantity: 1)
            grocery.items.append(newItem)
        }
    }
}


