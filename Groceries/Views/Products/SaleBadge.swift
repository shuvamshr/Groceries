//
//  SaleBadge.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftUI

/// A small yellow shelf-style ticket showing how much the customer saves.
struct SaleBadge: View {
    let promotion: Promotion
    let shelfPrice: Decimal
    var font: Font = .caption

    var body: some View {
        Text("Save \(promotion.saving(from: shelfPrice), format: .localCurrency)")
            .font(font)
            .fontWeight(.semibold)
            .foregroundStyle(.black)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.saleYellow, in: .rect(cornerRadius: 4))
    }
}

#Preview {
    SaleBadge(promotion: LocalGroceryRepository.sampleProducts[0].activePromotion()!, shelfPrice: 3.80)
}
