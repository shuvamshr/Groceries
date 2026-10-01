//
//  PriceLock.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation
import SwiftData

/// A locked-in price, saved on the device. Stores a snapshot of the product so
/// it still shows what was locked if the product later changes. A lock can't
/// be cancelled; it stays active until redeemed at checkout or it expires.
///
/// Because it only lives on the device, a real store couldn't trust it. A
/// production app would create and verify locks on the server.
@Model
final class PriceLock {
    static let durationInDays = 7

    @Attribute(.unique) var id: UUID
    var productID: UUID
    var productName: String
    var productBarcode: String
    var shelfPrice: Decimal
    var lockedPrice: Decimal
    var lockedAt: Date
    var expiresAt: Date
    var redeemedAt: Date? = nil

    init(product: Product, lockedAt: Date = .now) {
        self.id = UUID()
        self.productID = product.id
        self.productName = product.name
        self.productBarcode = product.barcode
        self.shelfPrice = product.shelfPrice(at: lockedAt)
        self.lockedPrice = product.currentPrice(at: lockedAt)
        self.lockedAt = lockedAt
        // Calendar days rather than a fixed number of seconds, so daylight
        // saving changes don't shift the expiry time.
        self.expiresAt = Calendar.current.date(byAdding: .day, value: Self.durationInDays, to: lockedAt)!
    }
}

// MARK: - State

extension PriceLock {
    /// The short value shown as the barcode.
    var code: String {
        String(id.uuidString.replacingOccurrences(of: "-", with: "").prefix(12))
    }

    var wasOnPromotion: Bool {
        lockedPrice < shelfPrice
    }

    var isRedeemed: Bool {
        redeemedAt != nil
    }

    func isExpired(at date: Date = .now) -> Bool {
        date >= expiresAt
    }

    func isActive(at date: Date = .now) -> Bool {
        !isRedeemed && !isExpired(at: date)
    }

    func redeem(at date: Date = .now) {
        redeemedAt = date
    }
}

extension Array where Element == PriceLock {
    /// A product can only have one active lock at a time.
    func activeLock(for product: Product) -> PriceLock? {
        first { $0.productID == product.id && $0.isActive() }
    }
}
