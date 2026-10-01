//
//  ProductFilter.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation

/// What the pills filter the product grid by.
enum ProductFilter: Hashable {
    case specials
    case category(String)
}
