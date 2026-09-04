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
        
                } else {
                    List {
                        ForEach(groceries) { grocery in
                            NavigationLink {
                                GroceryListView(grocery: grocery)
                            } label: {
                                HStack {
                                    Text(grocery.title)
                                    Spacer()
                                    Text("\(grocery.items.count)")
                                }
                            }
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
            .navigationTitle("Grocery List")
        }
    }
}

struct NewPlanView: View {
    
    @State private var title: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter New Grocery Title", text: $title)
                } header: {
                    Text("Details")
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark") {
                        addNewGrocery()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("New Grocery List")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
        }
    }
    
    private func addNewGrocery() {
        let newGrocery = Grocery(title: title)
        context.insert(newGrocery)
    }
}

#Preview {
    GroceryView()
}
