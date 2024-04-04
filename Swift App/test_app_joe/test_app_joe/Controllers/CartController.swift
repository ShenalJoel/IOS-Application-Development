import Foundation

class CartManager: ObservableObject {
    @Published var cartItems: [CartItem] = []
    var userId: String = ""
    static let shared = CartManager()
    @Published var checkoutSuccess: Bool = false
    
    func setUserAuth(_ userAuth: UserAuth) {
        self.userId = userAuth.userId // Set the userId from userAuth
       
    }
    
    
    func addToCart(product: Product, quantity: Int, color: String, size: String) {
        let newItem = CartItem(product: product, quantity: quantity, color: color, size: size)
        DispatchQueue.main.async {
            self.cartItems.append(newItem)
            //print("Item added, now have \(self.cartItems.count) items")  // Debugging
        }
    }
    
    // Check if the cart is empty
    var isCartEmpty: Bool {
        cartItems.isEmpty
    }
    
    func sendCartDataToAPI() {
        // Prepare the request body
        let requestBody: [String: Any] = [
            "userId": userId,
            "cartItems": cartItems.map { item in
                // Map each cart item to a dictionary representation
                return [
                    "productId": item.product.id,
                    "quantity": item.quantity,
                    "size": item.size,
                    "color": item.color
                ]
            }
        ]
        
        guard let url = URL(string: "http://172.16.16.71:3000/api/cartitems/") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: \(httpResponse.statusCode)")
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                    DispatchQueue.main.async {
                                self.checkoutSuccess = true
                            }
                }
            }.resume()
        } catch {
            print("Error encoding cart data: \(error.localizedDescription)")
        }
    }
    func fetchCartItems(userId: String) {
        guard let url = URL(string: "http://172.16.16.71:3000/api/cartitems/\(userId)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // Define structs to mirror the structure of the response
                struct ProductDetails: Decodable {
                    let _id: String
                    let categoryID: String
                    let name: String
                    let image: String
                    let prize: String
                    let availability: Int
                }
                
                struct CartItemResponse: Decodable {
                    let _id: String
                    let cartID: String
                    let productID: ProductDetails
                    let quantity: Int
                    let size: String
                    let color: String
                    let __v: Int
                }
                
                // Define a wrapper struct to capture the array of cart items
                struct CartItemsWrapper: Decodable {
                    let cartItems: [CartItemResponse]
                }
                
                // Decode the response data using the wrapper struct
                let decoder = JSONDecoder()
                let cartItemsWrapper = try decoder.decode(CartItemsWrapper.self, from: data)
                
                // Convert the decoded items to CartItem objects
                let convertedCartItems = cartItemsWrapper.cartItems.map { item in
                    CartItem(
                        product: Product(
                            id: item.productID._id,
                            categoryID: item.productID.categoryID,
                            name: item.productID.name,
                            price: item.productID.prize,
                            imageName: item.productID.image,
                            colors: nil, // Provide appropriate value for colors
                            sizes: nil    // Provide appropriate value for sizes
                            
                        ),
                        quantity: item.quantity,
                        color: item.color,
                        size: item.size,
                        isSelected: false, // Default value for isSelected
                        cartID: item.cartID
                    )
                }
                
                // Update the cartItems array with the fetched items
                DispatchQueue.main.async {
                    self.cartItems = convertedCartItems
                }
            } catch {
                print("Error decoding cart items: \(error.localizedDescription)")
            }
        }.resume()
    }

    
    // Function to reset cart items
      func resetCart() {
          self.cartItems = []
      }
}
