//
//  PriceChange.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation

/// One change to a product's regular price, recorded by a database trigger.
nonisolated struct PriceChange: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    let productID: UUID
    let price: Decimal
    let changedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, price
        case productID = "product_id"
        case changedAt = "changed_at"
    }
}
