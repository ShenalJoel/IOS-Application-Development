//
//  MyOrdersView.swift
//  test_app_joe
//
//  Created by Shenal Ockersz on 2024-03-25.
//

import Foundation
import SwiftUI

struct MyOrdersView: View {
    @ObservedObject var userAuth: UserAuth

    var body: some View {
        VStack {
            HStack {
                Text("My Orders")
                    .font(.headline)
                    
                Spacer()
                Button("View All") {
                    if userAuth.isUserLoggedIn {
                        
                    }else{
                        
                    }
                }
                
            }
            .padding(.bottom,15)
                // Your orders content here
               HStack(spacing: 20) {
                   OrderStatusView(status: "Unpaid",imageicon:"creditcard")
                   OrderStatusView(status: "Processing",imageicon:"archivebox")
                   OrderStatusView(status: "Shipped",imageicon:"truck.box")
                   OrderStatusView(status: "Review",imageicon:"ellipsis.message")
                   OrderStatusView(status: "Returns",imageicon:"shippingbox.and.arrow.backward")

                }
        }
        .frame(maxWidth: .infinity)
        
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct OrderStatusView: View {
    var status: String
    var imageicon: String
    var body: some View {
        VStack {
            Image(systemName: imageicon) // Replace with appropriate icons
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text(status)
               
        }
        
    }
}
