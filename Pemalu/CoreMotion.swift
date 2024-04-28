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
//var flag : Double = 0.0
var flag : Bool = false

public func startMotionUpdates() -> Bool{
    if motionManager.isAccelerometerAvailable {
        motionManager.accelerometerUpdateInterval = 0.25
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let accelerometerData = data else { return }
            let accelerationY = accelerometerData.acceleration.y

            // Check if motion is significant (adjust as needed)
            if abs(accelerationY) > 1.0 {

                motionCount += 1
//                playCustomHaptic()
//                print(abs(accelerationY))
//                flag = abs(accelerationY)
                flag = true
            }
            else{
                flag = false
            }
        }
    }
//    print(flag)
    return flag
}

func stopMotionUpdates() {
    motionManager.stopAccelerometerUpdates()
}
