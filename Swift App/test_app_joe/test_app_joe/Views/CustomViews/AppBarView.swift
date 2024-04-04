

import Foundation

import SwiftUI

struct AppBarView: View {
    var body: some View {
        HStack {
            Text("Your App Name")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
    }
}
