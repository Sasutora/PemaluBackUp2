//
//  CoreMotion.swift
//  Pemalu
//
//  Created by Rama Eka Hartono on 27/04/24.
//

import Foundation
import CoreMotion

var motionCount: Int = 0
let motionManager = CMMotionManager()

func startMotionUpdates() {
    if motionManager.isAccelerometerAvailable {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let accelerometerData = data else { return }
            let accelerationY = accelerometerData.acceleration.y

            // Check if motion is significant (adjust as needed)
            if abs(accelerationY) > 3.0 {

                motionCount += 1
                playCustomHaptic()
            }
        }
    }
}

func stopMotionUpdates() {
    motionManager.stopAccelerometerUpdates()
}
