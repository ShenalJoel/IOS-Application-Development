//
//  Category.swift
//  test_app_joe
//
//  Created by NIBM-LAB04-PC07 on 2024-03-22.
//

import Foundation

struct Category: Codable ,Equatable, Hashable{
    let id: String
    let name: String
    let imageName: String
    let __v: Int // This represents the "__v" key in your JSON data

    // Define CodingKeys enum to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Map "_id" key in JSON to "id" property in struct
        case name
        case imageName
        case __v
    }
}
