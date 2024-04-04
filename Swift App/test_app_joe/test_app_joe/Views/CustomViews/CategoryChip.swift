//
//  CategoryChip.swift
//  test_app_joe
//
//  Created by NIBM-LAB04-PC07 on 2024-03-22.
//

import Foundation
import SwiftUI

struct CategoryChip: View {
    let category: String
       let imageName: String
       let isSelected: Bool

       var body: some View {
           ZStack {
               Circle() // Change from RoundedRectangle to Circle
                   .fill(isSelected ? Color.white: Color.white)
                   .frame(width: 50, height: 50) // Make sure this is a square to get a perfect circle
                   // Border for selected state
                   .shadow(radius: isSelected ? 0 : 0) // Optional shadow for selected state

               Image(imageName) // Use your image here
                   .resizable()
                   .scaledToFit()
                   .clipShape(Circle())
                   .frame(width: 55, height: 55) // Slightly smaller than the Circle to fit within the border
           }
       }
}
