//
//  ConfettiOverlay.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 2/10/2026.
//

import SwiftUI

/// Celebrates a locked-in price with confetti across the whole screen.
/// Decorative only, so it ignores touches and stays out of VoiceOver.
struct ConfettiOverlay: View {
    /// The bundled burst runs for about 3.7s. Speeding it up keeps the tap and
    /// the barcode card closer together, and the tail is only stragglers.
    private static let speed: CGFloat = 1.6

    var onFinished: () -> Void

    var body: some View {
        LottieView(name: "confetti", speed: Self.speed, onFinished: onFinished)
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

#Preview {
    ProductImage(url: nil)
        .overlay { ConfettiOverlay {} }
}
