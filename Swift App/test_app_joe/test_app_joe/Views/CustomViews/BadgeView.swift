//
//  CustomCartTabBarItem.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-27.
//

import Foundation
import SwiftUI

//
//struct BadgeView: View {
//    var value: Int
//    
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            if value > 0 {
//                Circle()
//                    .foregroundColor(.red)
//                    .frame(width: 15, height: 15)
//                    .overlay(
//                        Text("\(value)")
//                            .font(Font.system(size: 12).bold())
//                            .foregroundColor(.white)
//                    )
//                    .offset(x: -110, y: 795)
//            }
//        }
//    }
//}

struct BadgeView: View {
    var value: Int
    
    var body: some View {
        GeometryReader { geometry in
            let badgeSize: CGFloat = 15
            let topOffset = geometry.size.height * 0.05
            let trailingOffset = geometry.size.width * 0.05
            
            ZStack(alignment: .topLeading) {
                if value > 0 {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: badgeSize, height: badgeSize)
                        .overlay(
                            Text("\(value)")
                                .font(Font.system(size: 12).bold())
                                .foregroundColor(.white)
                        )
                        .alignmentGuide(.top) { _ in topOffset }
                        .alignmentGuide(.trailing) { _ in trailingOffset }
                }
            }
        }
    }
}
