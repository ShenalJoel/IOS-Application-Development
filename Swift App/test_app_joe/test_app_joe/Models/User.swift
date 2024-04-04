//
//  User.swift
//  test_app_joe
//
//  Created by Shenal Ockersz on 2024-03-24.
//

import Foundation

// User model
struct User: Codable {
    let id: String
    let username: String
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case email
        case password
        
    }
    
}
