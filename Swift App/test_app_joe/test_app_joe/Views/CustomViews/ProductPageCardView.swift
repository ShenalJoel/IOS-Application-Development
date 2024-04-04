//
//  ProductPageCardView.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-30.
//

import Foundation
import SwiftUI

struct ProductPageCard: View {
    var product: Product
    @State private var showingProductDetails = false

    var body: some View {
        VStack {
            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.black)
                HStack{
                    Text("$\(product.price)")
                        .font(.headline)
                        .foregroundColor(.black) 
//
//                    Button(action: {
//                        showingProductDetails = true
//                    }) {
//                        Image(systemName: "cart.badge.plus") // Use a cart icon
//                            .frame(width: 44, height: 44) // Make the touch area larger for better accessibility
//                            .foregroundColor(.blue)
//                    } .sheet(isPresented: $showingProductDetails) {
//                        // For now, this opens a blank sheet. You can customize it later as needed.
//                      // Placeholder content
//                        ProductDetailView(product: product)
//                    }
                }
                
            }
           
        }
    }
}
