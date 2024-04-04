//
//  FilterView.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-29.
//

import Foundation
import SwiftUI

// Update the FilterView to use a List with multiple choice selections
struct FilterView: View {
    @Binding var selectedCategories: Set<String>
    @StateObject var categoryViewModel = CategoryViewModel.shared
    @State private var isFilterVisible = false // Track filter visibility
    
    @Binding var range: ClosedRange<Int>
    let rangeBounds: ClosedRange<Int>
    
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    isFilterVisible.toggle()
                }) {
                    HStack {
                        Text("Categories")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .bold()
                        Spacer()
                        Image(systemName: isFilterVisible ? "chevron.up" : "chevron.down")
                    }
                    .padding()
                }
                if isFilterVisible {
                    List {
    
                            ForEach(categoryViewModel.categories, id: \.id) { category in
                                MultipleSelectionRow(title: category.name, isSelected: selectedCategories.contains(category.id)) {
                                    if selectedCategories.contains(category.id) {
                                        selectedCategories.remove(category.id)
                                    } else {
                                        selectedCategories.insert(category.id)
                                    }
                                }
                            }
                        
                    }
                    .listStyle(GroupedListStyle())
                }
                Text("Range: \(range.lowerBound) - \(range.upperBound)")
                    .padding(.horizontal , 50)
                            RangeSliderView(value: $range, bounds: rangeBounds)
                                .frame(height: 50)
                                .padding(.horizontal , 50)
                            Spacer()
            }
            .navigationBarTitle("Filter")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            categoryViewModel.fetchCategories()
        }
    }
}
