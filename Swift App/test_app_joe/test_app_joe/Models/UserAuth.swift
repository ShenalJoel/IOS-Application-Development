//
//  UserAuth.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-26.
//

import Foundation

class UserAuth: ObservableObject {
    @Published var isUserLoggedIn = false {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    @Published var username = "" {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    @Published var userId = "" {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}
