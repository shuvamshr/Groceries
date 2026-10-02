//
//  PricePoint.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation

/// A point on the price history chart: what a customer paid from `date`
/// until the next point.
nonisolated struct PricePoint: Identifiable, Hashable {
    let date: Date
    let price: Decimal
    let isPromotion: Bool

    var id: Date { date }
}
