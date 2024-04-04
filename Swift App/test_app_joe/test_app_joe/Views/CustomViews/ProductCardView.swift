//
//  ProductCardView.swift
//  test_app_joe
//
//  Created by NIBM-LAB04-PC07 on 2024-03-22.
//

import Foundation
import SwiftUI

struct ProductCard: View {
    var product: Product

    var body: some View {
        VStack {
            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 5)

            Text(product.name)
                .font(.headline)
                .width(150)
                .foregroundColor(.primary)
                .lineLimit(1)

            Text("$\(product.price)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
