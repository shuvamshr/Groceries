//
//  Promotion.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation

nonisolated struct Promotion: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    let productID: UUID
    let salePrice: Decimal
    let startDate: Date
    let endDate: Date

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case salePrice = "sale_price"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

extension Promotion {
    func isRunning(at date: Date = .now) -> Bool {
        startDate <= date && date < endDate
    }

    func saving(from shelfPrice: Decimal) -> Decimal {
        shelfPrice - salePrice
    }
}
