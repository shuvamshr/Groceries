//
//  ProductDetailView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftData
import SwiftUI

struct ProductDetailView: View {
    let product: Product

    @Query private var priceLocks: [PriceLock]
    @Environment(\.modelContext) private var modelContext
    @State private var isConfirmingLock = false
    @State private var isCelebrating = false
    @State private var isScanning = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let activeLock {
                    PriceLockBarcodeCard(priceLock: activeLock)
                        .overlay { scanner }
                        // Scaling from the top settles the card into place
                        // without the long slide that shunts the rest of the
                        // page down in one go.
                        .transition(.scale(scale: 0.94, anchor: .top).combined(with: .opacity))
                }

                ProductCard(product: product, size: .large) {
                    lockButton
                }

                priceHistory
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .overlay { confetti }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                moreMenu
            }
        }
        .alert("Lock price at \(product.currentPrice().formatted(.localCurrency))?", isPresented: $isConfirmingLock) {
            Button("Lock Price", action: lockPrice)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You'll pay this price for \(product.name) for the next \(PriceLock.durationInDays) days, even if it goes up. Once locked, it can't be undone until the barcode is used at checkout.")
        }
    }
}

// MARK: - Subviews

private extension ProductDetailView {
    /// Fades and stops responding once locked. (`.disabled` would turn it grey.)
    var lockButton: some View {
        Button {
            isConfirmingLock = true
        } label: {
            Label(
                activeLock == nil ? "Lock Price" : "Price Locked",
                systemImage: activeLock == nil ? "lock.open" : "lock.fill"
            )
            .font(.body.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.regular)
        .opacity(activeLock == nil ? 1 : 0.4)
        .allowsHitTesting(activeLock == nil)
        .padding(.top, 4)
    }

    /// Sweeps across the middle of the barcode card while it's being "scanned".
    /// Full width, and the artboard's 328x208 shape gives it its height, so it
    /// sits as a band across the centre rather than covering the whole card.
    @ViewBuilder
    var scanner: some View {
        if isScanning {
            LottieView(name: "scanner", onFinished: finishScan)
                .aspectRatio(328.0 / 208.0, contentMode: .fit)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    var confetti: some View {
        if isCelebrating {
            ConfettiOverlay(onFinished: endCelebration)
        }
    }

    var priceHistory: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price History")
                .font(.headline)
            PriceHistoryChart(points: product.priceTimeline())
                .frame(height: 220)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground(cornerRadius: 24)
    }

    /// The scan option stands in for the store's checkout, which would mark
    /// the lock redeemed when it scans the barcode.
    var moreMenu: some View {
        Menu("More", systemImage: "ellipsis") {
            Button("Simulate Checkout Scan", systemImage: "barcode.viewfinder") {
                isScanning = true
            }
            .disabled(activeLock == nil || isScanning)
        }
    }
}

// MARK: - Locking

private extension ProductDetailView {
    var activeLock: PriceLock? {
        priceLocks.activeLock(for: product)
    }

    /// The confetti plays over the card rather than ahead of it: the card
    /// eases in on its own transition as the burst goes off, so the two land
    /// together.
    func lockPrice() {
        // `.smooth` rather than `.snappy`: no spring bounce for a card this tall.
        withAnimation(.smooth) {
            modelContext.insert(PriceLock(product: product))
        }
        isCelebrating = true
    }

    /// By the end of the animation every piece has fallen off-screen, so the
    /// overlay can just go.
    func endCelebration() {
        isCelebrating = false
    }

    /// The till only counts the lock as used once the scan has played out, so
    /// the card stays put for the whole sweep and is redeemed on the last frame.
    func finishScan() {
        isScanning = false
        withAnimation(.smooth) { activeLock?.redeem() }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: LocalGroceryRepository.sampleProducts[0])
    }
    .modelContainer(for: PriceLock.self, inMemory: true)
}
