//
//  SettingsView.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-25.
//
import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State private var showingLogoutAlert = false
    @ObservedObject var cartManager = CartManager.shared // Inject CartManager
    @Environment(\.presentationMode) var presentationMode // To dismiss the settings page
    
    var body: some View {
        VStack {
            
            if userAuth.isUserLoggedIn { // Show logout button only if logged in
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                        .font(.headline)
                }
                .padding()
                .alert(isPresented: $showingLogoutAlert) {
                    Alert(
                        title: Text("Logout"),
                        message: Text("Are you sure you want to logout?"),
                        primaryButton: .destructive(Text("Logout")) {
                            logout()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }.navigationTitle("Settings")
            .padding(.leading)
            .padding()
    }
    
    func logout() {
        // Perform logout actions here
        userAuth.isUserLoggedIn = false
        userAuth.username = "" // Reset username to default value
        cartManager.resetCart() // Reset cart items
        
        // Dismiss the settings page after logging out
        presentationMode.wrappedValue.dismiss()
    }
}

