//
//  EmptyCartView.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-26.
//

import Foundation
import SwiftUI

struct EmptyCartView: View {
    @Binding var isUserLoggedIn: Bool // Receive isUserLoggedIn binding from CartView
    @State private var selectedCategory: Category? = nil
    var body: some View {
        ScrollView {
            Spacer()
            HStack {
                Image(systemName: "cart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .padding()
                VStack {
                    Text("Your cart is empty")
                        .font(.title2)
                        .padding(.bottom, 2)
                    if isUserLoggedIn {
                        Text("Start adding items to your cart")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        Text("Log in to see shopping cart")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                NavigationLink(destination:  ProductsView(selectedCategory: $selectedCategory)) {
                    Text("Shop Now")
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .cornerRadius(10)
                }
                
                if !isUserLoggedIn {
                    NavigationLink(destination: LoginView()) {
                        Text("Sign in / Register")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}
