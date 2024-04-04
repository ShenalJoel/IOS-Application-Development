import SwiftUI

enum ActiveAlert: Identifiable {
    case noItemSelected, addToCartSuccess
    
    // Provide an `id` for SwiftUI to use
    var id: Int {
        switch self {
        case .noItemSelected:
            return 1
        case .addToCartSuccess:
            return 2
        }
    }
}

struct FilledCartView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var selectAll: Bool = false
    @EnvironmentObject var userAuth: UserAuth

    @State private var isCheckoutDisabled = true
    //@State private var showAlert = false
    @State private var activeAlert: ActiveAlert?
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Cart Items")
                            .font(.headline)
                        Spacer()
                    }.padding(.horizontal)
                }
                ScrollView {
                    VStack {
                        ForEach(cartManager.cartItems) { cartItem in
                            HStack {
                                Button(action: {
                                    cartManager.cartItems[cartManager.cartItems.firstIndex(where: { $0.id == cartItem.id })!].isSelected.toggle()
                                    updateSelectAll()
                                    updateCheckoutButtonState()
                                }) {
                                    Image(systemName: cartItem.isSelected ? "checkmark.circle.fill" : "circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(cartItem.isSelected ? .blue : .gray)
                                }
                                .padding()
                                
                                Image(cartItem.product.imageName)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                                VStack(alignment: .leading){
                                    Text(cartItem.product.name)
                                        .font(.headline)
                                        .lineLimit(1) // Limit to 1 line
                                        .minimumScaleFactor(0.5) // Adjust as needed
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack{
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("$\(cartItem.product.price)")
                                                .font(.subheadline)
                                                .bold()
                                            Text("Color: \(cartItem.color)")
                                                .font(.subheadline)
                                            Text("Size: \(cartItem.size)")
                                                .font(.subheadline)
                                        }
                                        .padding(.leading, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Spacer()
                                        
                                        QuantitySelector(quantity: $cartManager.cartItems[cartManager.cartItems.firstIndex(where: { $0.id == cartItem.id })!].quantity)
                                        
                                        // Delete button
                                        Button(action: {
                                            cartManager.cartItems.removeAll { $0.id == cartItem.id }
                                            updateCheckoutButtonState()
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .padding(.vertical, 8)
                        }
                        Divider().padding()
                    }
                }
                VStack {
                    Divider()
                    HStack {
                        Button(action: {
                            selectAll.toggle()
                            cartManager.cartItems.indices.forEach { index in
                                cartManager.cartItems[index].isSelected = selectAll
                            }
                            updateCheckoutButtonState()
                        }) {
                            Image(systemName: selectAll ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(selectAll ? .blue : .gray)
                            Text("Select All")
                        }
                        
                        Spacer()
                        
                        Text(" $\(calculateTotal(), specifier: "%.2f")")
                        
                        // Call sendCartDataToAPI function here
                        Button(action: {
                            if(!isCheckoutDisabled){
                            CartManager.shared.setUserAuth(userAuth)
                            cartManager.sendCartDataToAPI()
                            //cartManager.fetchCartItems()
                            }else{
                                activeAlert = .noItemSelected
                            }
                        }
                        ) {
                            Text("CHECKOUT")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                               
                        }.alert(item: $activeAlert) { activeAlert in
                            switch activeAlert {
                            case .noItemSelected:
                                return Alert(
                                    title: Text("Alert"),
                                    message: Text("No item is selected."),
                                    dismissButton: .default(Text("OK"))
                                )
                            case .addToCartSuccess:
                                return Alert(
                                    title: Text("Success"),
                                    message: Text("Your cart has been successfully checked out."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }.onChange(of: cartManager.checkoutSuccess) { success in
                            if success {
                                activeAlert = .addToCartSuccess
                                cartManager.checkoutSuccess = false // Reset to false to avoid repeated alerts.
                            }
                        }
                        
                    }

                    .padding()
                    .background(Color.white)
                    .padding(.bottom)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // Update checkout button state when view appears
            updateCheckoutButtonState()
        }
    }
    
    func calculateTotal() -> Double {
        cartManager.cartItems.filter { $0.isSelected }.reduce(0) {
            $0 + (Double($1.product.price) ?? 0.0) * Double($1.quantity)
        }
    }
    
    func updateSelectAll() {
        let allSelected = cartManager.cartItems.allSatisfy { $0.isSelected }
        selectAll = allSelected
    }
    
    func updateCheckoutButtonState() {
           // Enable checkout button if any item is selected, disable otherwise
        isCheckoutDisabled = cartManager.cartItems.filter { $0.isSelected }.isEmpty
       }
}


