//
//  SplashScreenView.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-31.
//

import Foundation
import SwiftUI

struct SplashScreen: View {
    @State private var startAnimation = false
    @State private var endSplash = false
    
    var body: some View {
        if !endSplash {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Logo and App Name
                VStack {
                    Image("logo2") // Replace "logo" with your actual logo image name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 700, height: 800)
                        .scaleEffect(startAnimation ? 0.6 : 0.4)
                        .opacity(startAnimation ? 3 : 0.5)
                    
//                    Text("Aurora")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .opacity(startAnimation ? 3 : 0.5)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 3)) {
                        startAnimation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            endSplash = true
                        }
                    }
                }
            }
            .transition(.scale.combined(with: .opacity))
        } else {
            // Transition to your main app content view here
            ContentView() // Replace ContentView() with your main view
        }
    }
}
