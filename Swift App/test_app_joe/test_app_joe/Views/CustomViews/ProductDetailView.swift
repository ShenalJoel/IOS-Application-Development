import SwiftUI

struct ProductDetailView: View {
    @State private var selectedColor: String? = nil
    @State private var selectedSize: String? = nil
    @State private var showAddedToCartMessage = false
    @State private var isSheetDismissed = false // Track the state of the sheet
    var product: Product
    @State private var addedToCart: Bool = false
    @ObservedObject var cartManager = CartManager.shared
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userAuth: UserAuth // Inject UserAuth environment object
    
    // Hardcoded values for testing
    let availableColors = ["Red", "Green", "Blue"]
    let availableSizes = ["S", "M", "L", "XL"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Assuming your ImageSliderView takes an array of strings for image names
                    Image(product.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350, height: 350)
                        .cornerRadius(8)
                    
                    Text(product.name)
                        .font(.title)
                        .padding(.top)
                    
                    Text("$\(product.price)")
                        .font(.title2)
                    
                    // Color selection
                    HStack {
                        Text("Color:")
                            .font(.headline)
                        ForEach(availableColors, id: \.self) { color in
                            Button(action: {
                                selectedColor = color
                           }) {
                                Text(color)
                                    .padding()
                                    .background(selectedColor == color ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                               
                        }
                    }
                    .padding(.vertical)
                    
                
                    // Size selection
                    HStack {
                        Text("Size:")
                            .font(.headline)
                        ForEach(availableSizes, id: \.self) { size in
                            Button(action: {
                                selectedSize = size
                            }) {
                                Text(size)
                                    .padding()
                                    .background(selectedSize == size ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    // Check if the user is logged in before adding to cart
                    if userAuth.isUserLoggedIn {
                        Button("ADD TO CART") {
                            addToCart()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.vertical)
                        .disabled(selectedColor == nil || selectedSize == nil)
                    } else {
                        NavigationLink(destination: LoginView()) {
                            Text("LOGIN TO ADD TO CART")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.vertical)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                    }
                }
                .padding()
                .alert(isPresented: $showAddedToCartMessage) {
                    Alert(
                        title: Text("Added to Cart"),
                        message: Text("Item added to cart successfully!"),
                        dismissButton: .default(Text("OK"), action: {
                            presentationMode.wrappedValue.dismiss()
                            isSheetDismissed = true // Update the state when the sheet is dismissed
                        })
                    )
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // Reset the state when the view appears
            isSheetDismissed = false
        }
    }
    
    func addToCart() {
        // Check if the item already exists in the cart
        if let existingCartItemIndex = cartManager.cartItems.firstIndex(where: { $0.product.id == product.id && $0.color == selectedColor && $0.size == selectedSize }) {
            // Increment the quantity of the existing item
            cartManager.cartItems[existingCartItemIndex].quantity += 1
        } else {
            // Add a new item to the cart
            cartManager.addToCart(
                product: product,
                quantity: 1,
                color: selectedColor ?? "S",
                size: selectedSize ?? "Red"
                
            )
        }
        showAddedToCartMessage = true

        // Hide the confirmation message after some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Dismiss the sheet only if it's not already dismissed manually
            if !isSheetDismissed {
                showAddedToCartMessage = false
            }
        }
    }
}
