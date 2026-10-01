//
//  View+Card.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftUI

extension View {
    /// The rounded white panel behind every card in the app.
    func cardBackground(cornerRadius: CGFloat = 16) -> some View {
        background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: cornerRadius))
    }
}
