//
//  DoubleRangeSlider.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-29.
//

import Foundation
import SwiftUI

struct RangeSliderView: View {
    let currentValue: Binding<ClosedRange<Int>>
    let sliderBounds: ClosedRange<Int>

    public init(value: Binding<ClosedRange<Int>>, bounds: ClosedRange<Int>) {
        self.currentValue = value
        self.sliderBounds = bounds
    }

    var body: some View {
        GeometryReader { geometry in
            SliderView(sliderSize: geometry.size, currentValue: currentValue, sliderBounds: sliderBounds)
        }
    }
}

struct SliderView: View {
    let sliderSize: CGSize
    @Binding var currentValue: ClosedRange<Int>
    let sliderBounds: ClosedRange<Int>

    var body: some View {
        let sliderViewYCenter = sliderSize.height / 2

        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray)
                .frame(height: 4)

            let sliderBoundDifference = sliderBounds.count
            let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)

            let leftThumbLocation: CGFloat = CGFloat(currentValue.lowerBound - sliderBounds.lowerBound) * stepWidthInPixel
            let rightThumbLocation = CGFloat(currentValue.upperBound - sliderBounds.lowerBound) * stepWidthInPixel

            lineBetweenThumbs(from: CGPoint(x: leftThumbLocation, y: sliderViewYCenter), to: CGPoint(x: rightThumbLocation, y: sliderViewYCenter))

            thumbView(position: CGPoint(x: leftThumbLocation, y: sliderViewYCenter), value: currentValue.lowerBound)
                .gesture(
                    DragGesture()
                        .onChanged { dragValue in
                            let dragLocation = dragValue.location
                            let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)

                            let newValue = sliderBounds.lowerBound + Int(xThumbOffset / stepWidthInPixel)

                            if newValue < currentValue.upperBound {
                                currentValue = newValue...currentValue.upperBound
                            }
                        }
                )

            thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: currentValue.upperBound)
                .gesture(
                    DragGesture()
                        .onChanged { dragValue in
                            let dragLocation = dragValue.location
                            let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)

                            let newValue = sliderBounds.lowerBound + Int(xThumbOffset / stepWidthInPixel)

                            if newValue > currentValue.lowerBound {
                                currentValue = currentValue.lowerBound...newValue
                            }
                        }
                )
        }
    }

    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(Color.blue, lineWidth: 4)
    }

    @ViewBuilder func thumbView(position: CGPoint, value: Int) -> some View {
        ZStack {
            Text(String(value))
                .font(.callout.bold())
                .offset(y: -20)

            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: 2)
                .contentShape(Rectangle())
        }
        .position(x: position.x, y: position.y)
    }
}
