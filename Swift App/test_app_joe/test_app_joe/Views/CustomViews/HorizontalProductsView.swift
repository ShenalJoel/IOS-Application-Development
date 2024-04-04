import Foundation
import SwiftUI

struct HorizontalProductsView: View {
    @StateObject var productController: ProductController
    let maxVisibleItems = 6
    
    let flashSaleEndTime: Date

    // Computed property for displayed products
    private var displayedProducts: [Product] {
        let shuffledProducts = productController.products.shuffled()
        return Array(shuffledProducts.prefix(maxVisibleItems))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("FLASH SALE")
                    .fontWeight(.bold)
                    .padding()

                RemainingTimeView(endDate: flashSaleEndTime)
                    .font(.headline)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                          LazyHStack(spacing: 15) {
                              // Loop through all products but only display up to maxVisibleItems
                              ForEach(displayedProducts.indices, id: \.self) { index in
                                  if index == productController.products.count - 1 || index == maxVisibleItems - 1 {
                                      // This is the last product or the last visible product if more than maxVisibleItems
                                      ZStack(alignment: .center) {
                                          ProductCard(product: displayedProducts[index])
                                              .opacity(0.5) // You can modify how the last item appears
                                          NavigationLink(destination: FlashSaleView()) {
                                              ViewMoreButton()
                                          }
                                      }
                                      .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove default button styling
                                  } else {
                                      // This is not the last product
                                      ProductCard(product: displayedProducts[index])
                                  }
                              }
                          }
                          .padding()
                      }
        }
        .onAppear {
            if productController.products.isEmpty {
                productController.fetchProducts()
            }
        }
    }
}

struct ViewMoreButton: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "arrow.right.circle.fill")
                .font(.title)
                .foregroundColor(.white)
            Text("View More")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7), .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(15)
        .contentShape(Rectangle())
    }
}
