//
//  Haptic.swift
//  Pemalu
//
//  Created by Rama Eka Hartono on 27/04/24.
//

import Foundation

import CoreHaptics

var hapticEngine: CHHapticEngine!
public func setupHaptics() {
    do {
        hapticEngine = try CHHapticEngine()
        try hapticEngine.start()
    } catch {
        print("Error starting haptic engine: \(error)")
    }
}


public func createCustomHapticPattern() -> CHHapticPattern {
    // Definisikan pola getaran Anda di sini
    let events: [CHHapticEvent] = [
        CHHapticEvent(eventType: .hapticContinuous,
                      parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 3),
                                   CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)],
                      relativeTime: 0,
                      duration: 0.2)
    ]

    do {
        let pattern = try CHHapticPattern(events: events, parameters: [])
        return pattern
    } catch {
        fatalError("Failed to create haptic pattern: \(error)")
    }
}

public func playCustomHaptic() {
    do {
        setupHaptics()
        let pattern = createCustomHapticPattern()
        let player = try hapticEngine.makePlayer(with: pattern)
        try player.start(atTime: CHHapticTimeImmediate)
    } catch {
        print("Failed to play custom haptic: \(error)")
    }
}
