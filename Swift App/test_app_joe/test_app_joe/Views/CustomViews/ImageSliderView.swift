//
//  ImageSliderView.swift
//  test_app_joe
//
//  Created by NIBM-LAB04-PC07 on 2024-03-22.
//

import Foundation

import SwiftUI

struct ImageSliderView: View {
    let images: [String] 

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(images, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.leading, imageName == images.first ? 15 : 0)
                        .padding(.trailing, imageName == images.last ? 15 : 0)
                }
            }
        }
        .frame(height: 200)
    }
}
