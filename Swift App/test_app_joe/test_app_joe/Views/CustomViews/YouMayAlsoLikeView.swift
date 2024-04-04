import SwiftUI

struct YouMayAlsoLikeView: View {
    @StateObject var productController = ProductController()
    @State private var displayedProducts = [Product]()
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("You May Also Like")
                .font(.headline)
                .padding()
                
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
        .background(Color.gray.opacity(0.075).edgesIgnoringSafeArea(.all))
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

