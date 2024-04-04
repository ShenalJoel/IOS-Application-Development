//
//  HomeView.swift
//  test_app_joe
//
//  Created by NIBM-LAB04-PC07 on 2024-03-22.
//

import Foundation
import SwiftUI
struct HomeView: View {
    @StateObject var productController = ProductController() // Creating a ProductController instance
    @State private var selectedCategory: Category? = nil
    @State private var redirectToProducts = false

    // Set the flash sale end time
    private var flashSaleEnd: Date {
         var calendar = Calendar.current
         calendar.timeZone = NSTimeZone.local // Adjust if necessary for your time zone
         let dateAtEndOfDay = calendar.startOfDay(for: Date()).addingTimeInterval(24 * 60 * 60 - 1)
         return dateAtEndOfDay
     }
    
    var body: some View {
        NavigationView { // Embed the content in a NavigationView
            ScrollView {
                VStack {
                    Text("Welcome to Aurora")
                        .font(.headline)
                    
                    Spacer()
                    
                    ImageSliderView(images: ["slider1", "slider2", "slider3"]).padding(.top, 20)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    CategoryListView(selectedCategory: $selectedCategory, redirectToProducts: $redirectToProducts) // Pass selectedCategory and
                    
                    Spacer()
                    
                    // Pass the flashSaleEnd time to HorizontalProductsView
                    HorizontalProductsView(productController: productController, flashSaleEndTime: flashSaleEnd)
                }
            }
            .onAppear {
                if redirectToProducts {
                    redirectToProducts = false // Reset redirectToProducts after navigation
                }
            }
            .background(NavigationLink(destination: ProductsView(selectedCategory: $selectedCategory), isActive: $redirectToProducts) { EmptyView() })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

