//
//  PriceLockListView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import SwiftData
import SwiftUI

struct PriceLockListView: View {
    enum Segment: String, CaseIterable {
        case active = "Active"
        case redeemed = "Redeemed"
    }

    let viewModel: ProductListViewModel

    @Query(sort: \PriceLock.lockedAt, order: .reverse) private var priceLocks: [PriceLock]
    @Environment(\.modelContext) private var modelContext
    @State private var segment: Segment = .active

    var body: some View {
        NavigationStack {
            ScrollView {
                segmentPicker

                switch segment {
                case .active: activeList
                case .redeemed: redeemedList
                }
            }
            .background(Color(.systemGroupedBackground))
            .overlay { emptyState }
            .navigationTitle("My Locked Prices")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
        }
    }
}

// MARK: - Locks

private extension PriceLockListView {
    var activeLocks: [PriceLock] {
        priceLocks.filter { $0.isActive() }
    }

    /// Redeemed, or expired without being used. Most recent first.
    var usedLocks: [PriceLock] {
        priceLocks
            .filter { !$0.isActive() }
            .sorted { ($0.redeemedAt ?? $0.expiresAt) > ($1.redeemedAt ?? $1.expiresAt) }
    }

    var visibleLocks: [PriceLock] {
        segment == .active ? activeLocks : usedLocks
    }
}

// MARK: - Subviews

private extension PriceLockListView {
    var segmentPicker: some View {
        Picker("Show", selection: $segment.animation(.snappy)) {
            ForEach(Segment.allCases, id: \.self) { segment in
                Text(segment.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }

    /// Cards that open the product page, which shows the barcode.
    var activeList: some View {
        LazyVStack(spacing: 16) {
            ForEach(activeLocks) { lock in
                if let product = viewModel.product(for: lock) {
                    NavigationLink(value: product) {
                        ActiveLockRow(priceLock: lock, imageURL: product.imageURL)
                    }
                    .buttonStyle(.plain)
                } else {
                    // No longer in the catalogue; the lock's snapshot still shows.
                    ActiveLockRow(priceLock: lock, imageURL: nil)
                }
            }
        }
        .padding()
    }

    /// A plain receipt-style history. Long-press a row to remove it.
    @ViewBuilder
    var redeemedList: some View {
        if !usedLocks.isEmpty {
            VStack(spacing: 0) {
                ForEach(usedLocks) { lock in
                    RedeemedLockRow(priceLock: lock)
                        .contextMenu {
                            Button("Remove", systemImage: "trash", role: .destructive) {
                                withAnimation { modelContext.delete(lock) }
                            }
                        }

                    if lock != usedLocks.last {
                        Divider()
                            .padding(.leading, 16)
                    }
                }
            }
            .cardBackground()
            .padding()
        }
    }

    @ViewBuilder
    var emptyState: some View {
        if visibleLocks.isEmpty {
            switch segment {
            case .active:
                ContentUnavailableView("No Active Locks", systemImage: "lock.open", description: Text("Lock in a price from the Products tab."))
            case .redeemed:
                ContentUnavailableView("Nothing Redeemed Yet", systemImage: "checkmark.seal", description: Text("Locks you've used at checkout will show up here."))
            }
        }
    }
}

#Preview {
    PriceLockListView(viewModel: ProductListViewModel(repository: LocalGroceryRepository()))
        .modelContainer(for: PriceLock.self, inMemory: true)
}
