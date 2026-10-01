//
//  ActiveLockRow.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftUI

/// An active lock as a card, styled like the product grid.
struct ActiveLockRow: View {
    let priceLock: PriceLock
    let imageURL: URL?

    var body: some View {
        HStack(spacing: 14) {
            ProductImage(url: imageURL)
                .frame(width: 76)

            VStack(alignment: .leading, spacing: 4) {
                Text(priceLock.productName)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(priceLock.lockedPrice, format: .localCurrency)
                        .font(.title3.bold())
                        .foregroundStyle(priceLock.wasOnPromotion ? .red : .primary)

                    if priceLock.wasOnPromotion {
                        Text(priceLock.shelfPrice, format: .localCurrency)
                            .font(.subheadline)
                            .strikethrough()
                            .foregroundStyle(.secondary)
                    }
                }

                Text("Expires \(priceLock.expiresAt, format: .relative(presentation: .named))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .cardBackground()
    }
}
