//
//  Product.swift
//  test_app_joe
//
//  Created by NIBM-LAB04-PC07 on 2024-03-22.
//

import Foundation


struct Product: Codable {
    let id: String
    let categoryID: String
    let name: String
    let price:String
    let imageName: String
    let colors:[String]?
    let sizes: [String]?

    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case categoryID
        case name
        case imageName="image"
        case price="prize"
        case colors
        case sizes
        
    }
    
 
}

