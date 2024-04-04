//
//  QuantitySelectorView.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-26.
//

import Foundation
import SwiftUI

struct QuantitySelector: View {
    @Binding var quantity: Int
    
    var body: some View {
        HStack {
            Button(action: {
                if quantity > 1 { quantity -= 1 }
            }) {
                Image(systemName: "minus.circle")
            }
            
            Text("\(quantity)")
            
            Button(action: {
                quantity += 1
            }) {
                Image(systemName: "plus.circle")
            }
        }
        .padding()
    }
}
