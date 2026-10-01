//
//  Decimal+Currency.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation

extension Locale {
    /// The device's currency, falling back to AUD.
    static var appCurrencyCode: String {
        current.currency?.identifier ?? "AUD"
    }
}

extension FormatStyle where Self == Decimal.FormatStyle.Currency {
    static var localCurrency: Self {
        .currency(code: Locale.appCurrencyCode)
    }
}

extension Decimal {
    /// Swift Charts plots `Double`s. Only use this for drawing; prices stay `Decimal`.
    var doubleValue: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
}
