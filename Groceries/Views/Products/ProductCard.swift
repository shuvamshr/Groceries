//
//  ProductCard.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftUI

/// The product card in the grid (`.compact`) and on the detail screen
/// (`.large`), so both always show the same details. `accessory` is an
/// optional slot at the bottom, used for the lock button.
struct ProductCard<Accessory: View>: View {
    enum Size {
        case compact, large
    }

    let product: Product
    var size: Size = .compact
    @ViewBuilder var accessory: Accessory

    var body: some View {
        VStack(alignment: .center, spacing: isLarge ? 14 : 10) {
            ProductImage(url: product.imageURL, cornerRadius: isLarge ? 12 : 8)

            if let promotion = product.activePromotion() {
                SaleBadge(promotion: promotion, shelfPrice: product.shelfPrice, font: isLarge ? .subheadline : .caption)
            }

            Text(product.name)
                .font(isLarge ? .title2 : .subheadline)
                .fontWeight(.semibold)
                .lineLimit(isLarge ? nil : 2)
                .multilineTextAlignment(.center)

            price

            accessory
        }
        .padding(isLarge ? 20 : 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground(cornerRadius: isLarge ? 24 : 16)
    }
}

// MARK: - Subviews

private extension ProductCard {
    var isLarge: Bool { size == .large }
    var priceFont: Font { isLarge ? .largeTitle.bold() : .title3.bold() }
    var secondaryFont: Font { isLarge ? .subheadline : .caption }

    @ViewBuilder
    var price: some View {
        if let promotion = product.activePromotion() {
            VStack(spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(promotion.salePrice, format: .localCurrency)
                        .font(priceFont)
                        .foregroundStyle(.red)
                    Text(product.shelfPrice, format: .localCurrency)
                        .font(isLarge ? .title3 : .subheadline)
                        .strikethrough()
                        .foregroundStyle(.secondary)
                }
                Text("Ends \(promotion.endDate, format: .relative(presentation: .named))")
                    .font(secondaryFont)
                    .foregroundStyle(.secondary)
            }
        } else {
            Text(product.shelfPrice, format: .localCurrency)
                .font(priceFont)
        }
    }
}

extension ProductCard where Accessory == EmptyView {
    init(product: Product, size: Size = .compact) {
        self.init(product: product, size: size) { EmptyView() }
    }
}

#Preview {
    ScrollView {
        HStack(alignment: .top, spacing: 16) {
            ProductCard(product: LocalGroceryRepository.sampleProducts[0])
            ProductCard(product: LocalGroceryRepository.sampleProducts[1])
        }
        ProductCard(product: LocalGroceryRepository.sampleProducts[0], size: .large)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
