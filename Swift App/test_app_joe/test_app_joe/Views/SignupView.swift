import SwiftUI

// Signup view
struct SignupView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var errorMessage = ""
    @State private var isSignupSuccessful = false
    
    // UserController to handle signup API
    let userController = UserController()

    var body: some View {
        VStack {
            Text("Signup")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(DefaultTextFieldStyle())
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)

            TextField("Email", text: $email)
                .textFieldStyle(DefaultTextFieldStyle())
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)

            
            SecureField("Password", text: $password)
                .textFieldStyle(DefaultTextFieldStyle())
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(DefaultTextFieldStyle())
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Signup") {
                signup()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            .padding()

            Spacer()
        }
        .padding()
        .alert(isPresented: $isSignupSuccessful) {
            Alert(title: Text("Signup Successful"), message: Text("You have successfully signed up."), dismissButton: .default(Text("OK")))
        }
    }
    
    // Function to handle signup
        func signup() {
          
            // Check if username is empty
            guard !username.isEmpty else {
                errorMessage = "Username cannot be empty"
                return
            }

            // Check if email is empty
            guard !email.isEmpty else {
                errorMessage = "Email cannot be empty"
                return
            }

            // Check if password is empty
            guard !password.isEmpty else {
                errorMessage = "Password cannot be empty"
                return
            }

            // Check if passwords match
            guard password == confirmPassword else {
                errorMessage = "Passwords do not match"
                return
            }
            // Check if passwords match
            guard password == confirmPassword else {
                errorMessage = "Passwords do not match"
                return
            }
            
            
            // Call the signup API
            userController.signup(username: username, email: email, password: password) { result in
                switch result {
                case .success(let user): // Use '_' to indicate the value is not used
                    // Signup successful, reset fields and show success message
                    username = ""
                    email = ""
                    password = ""
                    confirmPassword = ""
                    errorMessage = ""
                    isSignupSuccessful = true
                    
                    print("Signup successful! Response data: \(user)")
                    
                case .failure(let error):
                    // Signup failed, set error message
                    errorMessage = error.localizedDescription
                }
            }
        }
}
