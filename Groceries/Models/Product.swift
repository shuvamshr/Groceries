//
//  Product.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation

/// Read-only catalogue data from the server, so a `Codable` struct rather than
/// a SwiftData model. Prices are `Decimal` because `Double` can't represent
/// most money amounts exactly.
nonisolated struct Product: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    let name: String
    let barcode: String
    let category: String
    let imageURL: URL?
    let shelfPrice: Decimal
    let promotions: [Promotion]
    let priceHistory: [PriceChange]

    enum CodingKeys: String, CodingKey {
        case id, name, barcode, category, promotions
        case imageURL = "image_url"
        case shelfPrice = "shelf_price"
        case priceHistory = "price_history"
    }
}

// MARK: - Pricing

extension Product {
    func activePromotion(at date: Date = .now) -> Promotion? {
        promotions.first { $0.isRunning(at: date) }
    }

    /// The regular price that applied at `date`.
    func shelfPrice(at date: Date) -> Decimal {
        priceHistory
            .filter { $0.changedAt <= date }
            .max { $0.changedAt < $1.changedAt }?
            .price ?? shelfPrice
    }

    /// What a customer pays at `date`: the sale price if one is running,
    /// otherwise the regular price.
    func currentPrice(at date: Date = .now) -> Decimal {
        activePromotion(at: date)?.salePrice ?? shelfPrice(at: date)
    }

    /// Regular price changes and promotions merged into one history for the chart.
    func priceTimeline(until end: Date = .now) -> [PricePoint] {
        let changeDates = priceHistory.map(\.changedAt)
            + promotions.flatMap { [$0.startDate, $0.endDate] }
            + [end]

        let points = Set(changeDates)
            .filter { $0 <= end }
            .sorted()
            .map { date in
                PricePoint(date: date, price: currentPrice(at: date), isPromotion: activePromotion(at: date) != nil)
            }

        // Drop points where nothing changed, but keep the last so the line reaches `end`.
        return points.enumerated().compactMap { index, point in
            let previous = index > 0 ? points[index - 1] : nil
            let changed = previous?.price != point.price || previous?.isPromotion != point.isPromotion
            return changed || index == points.count - 1 ? point : nil
        }
    }
}
