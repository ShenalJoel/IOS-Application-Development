import Foundation

class ProductController: ObservableObject {
    @Published var products = [Product]()

    func fetchProducts() {
        guard let url = URL(string: "http://172.16.16.71:3000/api/products") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Check for errors or invalid response
            guard let data = data, error == nil else {
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Decode the JSON data
            let decoder = JSONDecoder()
            do {
                let fetchedProducts = try decoder.decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self.products = fetchedProducts
                    
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
