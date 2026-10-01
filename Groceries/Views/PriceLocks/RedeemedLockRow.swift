//
//  RedeemedLockRow.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftUI

/// One line of the redeemed history: product and date, then the price paid.
struct RedeemedLockRow: View {
    let priceLock: PriceLock

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(priceLock.productName)
                    .font(.subheadline.weight(.semibold))

                status
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(priceLock.lockedPrice, format: .localCurrency)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(priceLock.isRedeemed ? .primary : .secondary)
                .strikethrough(!priceLock.isRedeemed)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(.rect) // the whole row responds to long-press
    }

    @ViewBuilder
    private var status: some View {
        if let redeemedAt = priceLock.redeemedAt {
            Text(redeemedAt, format: .dateTime.day().month().year().hour().minute())
        } else {
            Text("Expired unused")
        }
    }
}
