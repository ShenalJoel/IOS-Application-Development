import Foundation
import SwiftUI

struct FlashSaleView: View {
    @StateObject var productController = ProductController()
    @State private var displayedProducts = [Product]() // Assuming Product is your model
    @State private var isLoading = true // State to track loading status

    private var flashSaleEndDate: Date {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateAtEndOfDay = calendar.startOfDay(for: Date()).addingTimeInterval(24 * 60 * 60 - 1)
        return dateAtEndOfDay
    }

    var body: some View {
        VStack {
            Text("FLASH SALE")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Great Quality & Big Discounts")
                .foregroundColor(.gray)
                .padding(.bottom, 5)

            RemainingTimeView(endDate: flashSaleEndDate)
                .padding(.bottom, 20)

            // Use a ZStack to overlay the loading indicator on top of the content
            ZStack {
                // Content
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(displayedProducts, id: \.id) { product in
                            ProductRow(product: product) // Ensure ProductRow is correctly implemented
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
                .opacity(isLoading ? 0 : 1) // Hide content when loading

                // Loading indicator
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .padding()
                }
            }
        }
        .background(Color.yellow.edgesIgnoringSafeArea(.all))
        .onAppear {
            if productController.products.isEmpty {
                productController.fetchProducts()
                // Simulate a network delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.updateDisplayedProducts()
                }
            } else {
                self.updateDisplayedProducts()
            }
        }
    }

    private func updateDisplayedProducts() {
        if productController.products.count > 20 {
            displayedProducts = Array(productController.products.shuffled().prefix(20))
        } else {
            displayedProducts = productController.products
        }
        isLoading = false // Update loading status
    }
}

struct FlashSaleView_Previews: PreviewProvider {
    static var previews: some View {
        FlashSaleView()
    }
}
