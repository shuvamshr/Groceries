//
//  ProductImage.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftUI

/// A square product photo. The grey square shows while loading, on failure,
/// or when there's no URL.
struct ProductImage: View {
    let url: URL?
    var cornerRadius: CGFloat = 8

    var body: some View {
        Color(.systemGray5)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    }
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
    }
}

#Preview {
    HStack {
        ProductImage(url: LocalGroceryRepository.sampleProducts[0].imageURL)
        ProductImage(url: nil)
    }
    .padding()
}
