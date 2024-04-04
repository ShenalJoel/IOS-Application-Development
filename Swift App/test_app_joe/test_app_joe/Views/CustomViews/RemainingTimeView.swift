//
//  RemainingTimeView.swift
//  test_app_joe
//
//  Created by Shenal Ockersz on 2024-03-24.
//

import Foundation
import SwiftUI

struct RemainingTimeView: View {
    let endDate: Date
    @State private var timeRemaining: String = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(endDate: Date) {
        self.endDate = endDate
        self._timeRemaining = State(initialValue: self.formatTimeRemaining(until: endDate))
    }

    var body: some View {
        Text("Ends in \(timeRemaining)")
            .font(.headline)
            .onReceive(timer) { _ in
                timeRemaining = formatTimeRemaining(until: endDate)
            }
            .onAppear {
                // Update immediately when the view appears.
                self.timeRemaining = self.formatTimeRemaining(until: endDate)
            }
    }

    private func formatTimeRemaining(until endDate: Date) -> String {
        let timeInterval = endDate.timeIntervalSinceNow
        if timeInterval <= 0 {
            return "00:00:00"
        } else {
            let hours = Int(timeInterval) / 3600
            let minutes = Int(timeInterval) / 60 % 60
            let seconds = Int(timeInterval) % 60
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
    }
}

