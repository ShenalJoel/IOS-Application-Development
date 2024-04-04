import Foundation

class UserController {
    // Error types for UserController
    enum UserControllerError: Error {
        case invalidURL
        case invalidRequest
        case invalidResponse
        case invalidCredentials
        case networkError
        case generic(message: String)
    }

    // Method to handle user login
        func login(username: String, password: String, completion: @escaping (Result<User, UserControllerError>) -> Void) {
            // Construct the URL for the login endpoint
            guard let loginURL = URL(string: "http://172.16.16.71:3000/api/login") else {
                completion(.failure(.invalidURL))
                return
            }
            
            // Prepare the request
            var request = URLRequest(url: loginURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set content type
            
            // Prepare the request body
            let requestBody: [String: Any] = [
                "username": username,
                "password": password
            ]
            
            // Convert request body to data
            guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
                completion(.failure(.invalidRequest))
                return
            }
            
            // Attach request body to the request
            request.httpBody = requestBodyData
            
            // Perform the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Check for errors
                if let error = error {
                    completion(.failure(.networkError))
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    // Print invalid response
                    completion(.failure(.invalidResponse))
                    print("Invalid response")
                    return
                }

                // Check if the status code is in the 200 range
                guard (200...299).contains(httpResponse.statusCode) else {
                    // Response is not in the 200 range, handle accordingly
                    completion(.failure(.invalidResponse))
                    print("Invalid status code: \(httpResponse.statusCode)")
                    return
                }
                
                // Parse the response data and decode into User object
                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode([String: User].self, from: data!)
                    if let user = responseData["user"] {
                        completion(.success(user))
                    } else {
                        completion(.failure(.invalidResponse))
                        print("User data not found in response")
                    }
                } catch {
                    print("Error decoding user data: \(error)")
                    completion(.failure(.invalidResponse))
                }
            }.resume()
        }
    
    // Method to handle user signup
    func signup(username: String, email: String, password: String, completion: @escaping (Result<User, UserControllerError>) -> Void) {
        // Construct the URL for the signup endpoint
        guard let signupURL = URL(string: "http://172.16.16.71:3000/api/users") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: signupURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let requestBody: [String: Any] = [
            "username": username,
            "email": email,
            "password": password
        ]
        guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(.invalidRequest))
            return
        }
        request.httpBody = requestBodyData
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            // Check for valid response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Parse the response data
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(.generic(message: error.localizedDescription)))
                }
            }
        }.resume()
    }
}
