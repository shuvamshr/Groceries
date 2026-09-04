//
//  GroceryView.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 4/9/2026.
//

import SwiftUI
import SwiftData

struct GroceryView: View {
    
    @Query private var groceries: [Grocery] = []
    @State private var newPlanSheetShowing: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if groceries.isEmpty {
                    ContentUnavailableView("No Groceries Yet", systemImage: "basket.fill", description: Text("Add New Grocery List to get Started"))
                        .navigationTitle("Grocery List")
                } else {
                    List {
                        ForEach(groceries) { grocery in
                            
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add New Plan", systemImage: "plus") {
                        newPlanSheetShowing.toggle()
                    }
                }
            }
            .sheet(isPresented: $newPlanSheetShowing) {
                NewPlanView()
            }
        }
    }
}

struct NewPlanView: View {
    
    @State private var title: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter New Plan", text: $title)
                } header: {
                    Text("Details")
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark") {
                        
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("New Plan")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    GroceryView()
}
