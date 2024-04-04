import SwiftUI

struct ContentView: View {
    @StateObject var userAuth = UserAuth()
    @ObservedObject var cartManager = CartManager.shared // Create an instance of CartManager
    @State private var selectedCategory: Category? = nil
    
    var body: some View {
        TabView {
            HomeView()
                .background(Color(UIColor.systemGray5))
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ProductsView(selectedCategory: $selectedCategory)
                .tabItem {
                    Label("Products", systemImage: "bag.fill")
                }
            
            FavoriteView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            
            CartView()
                .environmentObject(userAuth)
                .environmentObject(cartManager) // Provide CartManager to the environment
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
                .badge(cartManager.cartItems.count) // Set badge count directly
                
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .environmentObject(userAuth)
    }
}
