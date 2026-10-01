//
//  PriceLockBarcodeCard.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftUI

/// An active lock's barcode, locked price and live expiry countdown.
struct PriceLockBarcodeCard: View {
    let priceLock: PriceLock

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Label("Locked Price", systemImage: "barcode")
                    .font(.headline)
                Spacer()
                Text(priceLock.lockedPrice, format: .localCurrency)
                    .font(.title2.bold())
            }

            barcode

            countdown
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .cardBackground(cornerRadius: 24)
    }
}

// MARK: - Subviews

private extension PriceLockBarcodeCard {
    /// Always on white, even in dark mode, so scanners can read it.
    @ViewBuilder
    var barcode: some View {
        if let image = BarcodeGenerator.code128(from: priceLock.code) {
            VStack(spacing: 8) {
                Image(uiImage: image)
                    .interpolation(.none) // keeps the bars sharp when scaled
                    .resizable()
                    .frame(height: 90)
                Text(priceLock.code)
                    .font(.callout.monospaced())
                    .foregroundStyle(.black)
            }
            .padding()
            .background(.white, in: .rect(cornerRadius: 12))
        }
    }

    /// `TimelineView` redraws once a second, so the countdown ticks without a timer.
    var countdown: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            if priceLock.isExpired(at: context.date) {
                Label("Expired", systemImage: "clock.badge.xmark")
                    .foregroundStyle(.red)
            } else {
                HStack {
                    Text("Expires in")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(timeRemaining(at: context.date))
                        .font(.headline)
                        .monospacedDigit()
                }
            }
        }
    }

    /// e.g. "6d 23h 59m 12s".
    func timeRemaining(at date: Date) -> String {
        let seconds = max(0, Int(priceLock.expiresAt.timeIntervalSince(date)))
        return Duration.seconds(seconds)
            .formatted(.units(allowed: [.days, .hours, .minutes, .seconds], width: .narrow))
    }
}
