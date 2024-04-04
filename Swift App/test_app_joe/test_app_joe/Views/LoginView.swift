import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var errorMessage = ""

    let userController = UserController()
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.top, 20)

            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                } else {
                    SecureField("Password", text: $password)
                }
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.top, 20)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 20)
            }

            Button("Login") {
                login()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(8)
            .padding(.top, 20)
            .frame(minWidth: 500, maxWidth: .infinity) // Set minimum and maximum width

            Spacer()
        }
       
        .padding(.horizontal)
        .background(Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all))
    }

    func login() {
        // Validate credentials
        guard validateCredentials() else {
            errorMessage = "Please enter valid username and password"
            return
        }

        // Call the login API
        userController.login(username: username, password: password) { result in
            switch result {
            case .success(let user):
                print(user);
                // Login successful, reset fields and show success message
                DispatchQueue.main.async {
                    password = ""
                    errorMessage = ""
                    userAuth.username = user.username // Update userAuth with the username
                    userAuth.isUserLoggedIn = true
                    userAuth.userId = user.id
                }
                // Optionally, you can save user information to UserDefaults if needed
                UserDefaults.standard.set(user.id, forKey: "UserID")
                UserDefaults.standard.set(user.username, forKey: "Username")
                UserDefaults.standard.set(user.email, forKey: "Email")
                
                CartManager.shared.fetchCartItems(userId: user.id)
                

            case .failure(let error):
                // Login failed, set error message based on error type
                switch error {
                case .invalidURL:
                    errorMessage = "Invalid URL"
                case .invalidRequest:
                    errorMessage = "Invalid login request"
                case .invalidResponse:
                    errorMessage = "Invalid response from server"
                case .invalidCredentials:
                    errorMessage = "Invalid username or password"
                case .networkError:
                    errorMessage = "Network error occurred"
                case .generic(let message):
                    errorMessage = message
                }
            }
        }
    }


    func validateCredentials() -> Bool {
        // Check if username is empty
        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty"
            return false
        }

        // Check if password is empty
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return false
        }

        return true
    }
}
