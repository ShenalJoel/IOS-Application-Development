import SwiftUI
import SwiftUIX

struct ProductsView: View {
    @StateObject var productController = ProductController()
    @Binding var selectedCategory: Category?
    @State private var selectedCategories: Set<String> = []
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var sortingOption = "Recommended"
    @State private var isPriceLowToHigh = true // Default sorting order is low to high
    @State var isEditing: Bool = false
    @State private var isLoading = true
    
    @State private var maxPrice: Int = 6000 // Default max price
    @State private var priceRange: ClosedRange<Int> = 0...6000
    
    @StateObject var categoryViewModel = CategoryViewModel.shared
    
    var availableCategories: [String] {
        categoryViewModel.categories.map { $0.id }
    }
    
    var filteredProducts: [Product] {
        var filteredProducts = productController.products
        
        if !selectedCategories.isEmpty {
            filteredProducts = filteredProducts.filter { selectedCategories.contains($0.categoryID) }
        } else if let selectedCategory = selectedCategory {
            filteredProducts = filteredProducts.filter { $0.categoryID == selectedCategory.id }
        }
        
        // Apply price range filter
        filteredProducts = filteredProducts.filter { product in
            let price = Double(product.price) ?? 0
            return priceRange.contains(Int(price))
        }
        
        return filteredProducts
    }
    
    var sortedProducts: [Product] {
        var sorted = filteredProducts
        
        // Apply search filter
        if !searchText.isEmpty {
            sorted = sorted.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Apply sorting based on selected option
        if !sortingOption.isEmpty {
            sorted.sort { product1, product2 in
                let price1 = Double(product1.price) ?? 0
                let price2 = Double(product2.price) ?? 0
                return isPriceLowToHigh ? price1 < price2 : price1 > price2
            }
        }
        
        return sorted
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBar("Search...", text: $searchText, isEditing: $isEditing)
                    Button("Filter") {
                        showFilters.toggle()
                    }
                }
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Menu {
                            Button("Recommended", action: { sortingOption = "Recommended" })
                            Button("New Arrivals", action: { sortingOption = "New Arrivals" })
                            Button("Top Rated", action: { sortingOption = "Top Rated" })
                        } label: {
                            HStack {
                                Text(sortingOption)
                                Image(systemName: "arrowtriangle.down.fill")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            isPriceLowToHigh.toggle()
                        }) {
                            HStack {
                                Text("Price")
                                Image(systemName: isPriceLowToHigh ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                
                ZStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(sortedProducts, id: \.id) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductPageCard(product: product)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }
                    .padding()
                    .opacity(isLoading ? 0 : 1) // Hide content while loading
                    
                    // Loading indicator
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle("Products", displayMode: .inline)
            .sheet(isPresented: $showFilters) {
                FilterView(selectedCategories: $selectedCategories, range: $priceRange, rangeBounds: 0...maxPrice)
                                   .onAppear {
                                       maxPrice = calculateMaxPrice()
                                   }
            }
            .onAppear {
                if productController.products.isEmpty {
                    productController.fetchProducts()
                    // Add a delay to simulate network loading
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isLoading = false // Update loading state
                        // Additional logic to update products if necessary
                    }
                } else {
                    self.isLoading = false // Immediately hide loader if products are already loaded
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
       

    
    // Function to calculate the maximum price of the products
    private func calculateMaxPrice() -> Int {
        let prices = productController.products.compactMap { Int($0.price) }
        return prices.max() ?? 1000 // Default to 1000 if no products or prices
    }
}


// Update the MultipleSelectionRow to show checkmarks for selected items
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                action()
            }) {
                HStack {
                    Text(title)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}
