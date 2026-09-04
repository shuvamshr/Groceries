//
//  GroceryItemView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 4/9/2026.
//

import SwiftUI
import Lottie
import SwiftData

struct GroceryItemView: View {
    
    @Bindable var item: GroceryItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: item.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 42, height: 42)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text(item.title)
                Text("Qty: \(item.quantity)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.secondary)
                   
                if let notes = item.notes {
                    HStack(alignment: .top) {
                        Image(systemName: "pencil.and.list.clipboard")
                        Text(notes)
                    }
                    .font(.caption)
                    .padding(.top, 4)
                    .foregroundStyle(Color.secondary)
                  
                    
                }
            }
            Spacer()
            Button {
                withAnimation {
                    item.isPurchased.toggle()
                }
            } label: {
                if item.isPurchased {
                    LottieView(animation: .named("success"))
                        .playing(loopMode: .playOnce)
                        .animationSpeed(2.0)
                        .frame(width: 28, height: 28)
                } else {
                    Image(systemName: "circle")
                        .imageScale(.large)
                        .foregroundStyle(Color.gray.opacity(0.5) )
                }
            }
        }
        .strikethrough(item.isPurchased)
    }
}

