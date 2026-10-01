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

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let activeLock {
                    PriceLockBarcodeCard(priceLock: activeLock)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                ProductCard(product: product, size: .large) {
                    lockButton
                }

                priceHistory
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
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
                withAnimation(.snappy) { activeLock?.redeem() }
            }
            .disabled(activeLock == nil)
        }
    }
}

// MARK: - Locking

private extension ProductDetailView {
    var activeLock: PriceLock? {
        priceLocks.activeLock(for: product)
    }

    func lockPrice() {
        withAnimation(.snappy) {
            modelContext.insert(PriceLock(product: product))
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: LocalGroceryRepository.sampleProducts[0])
    }
    .modelContainer(for: PriceLock.self, inMemory: true)
}
