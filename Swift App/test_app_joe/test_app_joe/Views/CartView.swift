import Foundation
import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var userAuth: UserAuth
    @State private var isLoggedIn: Bool = false // Added state variable to track login status

    var body: some View {
        NavigationView {
            if cartManager.cartItems.isEmpty {
                ScrollView {
            
                    EmptyCartView(isUserLoggedIn: $isLoggedIn) // Pass isUserLoggedIn binding here
                    YouMayAlsoLikeView()
                }
            } else {
                FilledCartView()
            }
        }
        .onReceive(userAuth.$isUserLoggedIn) { newValue in
            isLoggedIn = newValue // Update isLoggedIn when isUserLoggedIn changes
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

