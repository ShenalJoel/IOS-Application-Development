//
//  CategoryViewModel.swift
//  test_app_joe
//
//  Created by NIBM-LAB04-PC07 on 2024-03-22.
//
import Foundation

class CategoryViewModel: ObservableObject {
    @Published var categories = [Category]()
    static let shared = CategoryViewModel()

    func fetchCategories() {
        guard let url = URL(string: "http://172.16.16.71:3000/api/categories") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            let decoder = JSONDecoder()
            do {
                let fetchedCategories = try decoder.decode([Category].self, from: data)
                DispatchQueue.main.async {
                    self.categories = fetchedCategories
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
        
        func fetchCategoryById(byID categoryID: String, completion: @escaping (Category?) -> Void) {
            // Assuming you have a backend API endpoint to fetch category details by ID
            //let test = "660035bc66a75746610fb59f"
            // Construct the URL for fetching category details by ID
            guard let url = URL(string: "http://172.16.16.71:3000/api/categories/\(categoryID)") else {
                print("Invalid URL")
                completion(nil)
                return
            }
            
            // Create a URLRequest
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Perform the network request
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Check for errors or invalid response
                guard let data = data, error == nil else {
                    print("Error fetching category: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                
                // Decode the JSON data into a Category object
                do {
                    let category = try JSONDecoder().decode(Category.self, from: data)
                    completion(category)
                } catch {
                    print("Error decoding category JSON: \(error)")
                    completion(nil)
                }
            }.resume()
        }
}
