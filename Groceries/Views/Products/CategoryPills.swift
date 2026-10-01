//
//  CategoryPills.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftUI

/// "Today's Specials" plus one pill per category. Tapping the selected pill
/// again clears the filter.
struct CategoryPills: View {
    let categories: [String]
    @Binding var selection: ProductFilter?

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                pill("Today's Specials", filter: .specials, highlight: .saleYellow, highlightedText: .black)

                ForEach(categories, id: \.self) { category in
                    pill(category, filter: .category(category))
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16, for: .scrollContent)
    }

    private func pill(
        _ title: String,
        filter: ProductFilter,
        highlight: Color = .accentColor,
        highlightedText: Color = .white
    ) -> some View {
        let isSelected = selection == filter

        return Button {
            withAnimation(.snappy) { selection = isSelected ? nil : filter }
        } label: {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundStyle(isSelected ? highlightedText : .primary)
                .background(isSelected ? highlight : Color(.secondarySystemGroupedBackground), in: .capsule)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CategoryPills(categories: ["Bakery", "Dairy"], selection: .constant(.specials))
}
