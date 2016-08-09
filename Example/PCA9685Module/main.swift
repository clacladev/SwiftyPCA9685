//
//  main.swift
//  SwiftyPCA9685
//
//  Created by Claudio Carnino on 09/08/2016.
//  Copyright © 2016 Tugulab. All rights reserved.
//

import Foundation
import Glibc


print("Starting the PCA9685Module example")

// Initialize the module
guard let smBus = try? SMBus(busNumber: 1) else {
    fatalError("It has not been possible to open the I2C bus")
}

// Throws should be managed properly! This is an example so we're going to ignore them
let module = try! PCA9685Module(smBus: smBus, address: 0x40)
try! module.set(pwmFrequency: 1000)

let redLedChannel = PCA9685Module.Channel(rawValue: 0)!
let yellowLedChannel = PCA9685Module.Channel(rawValue: 1)!

defer {
    // TODO: Reset
    try! module.set(channel: redLedChannel, dutyCycle: 0.0)
    try! module.set(channel: yellowLedChannel, dutyCycle: 0.0)
}

let exampleDuration: TimeInterval = 10.0
let cycleDuration: TimeInterval = 0.01
let numberExampleCycles = exampleDuration / cycleDuration

for index in 0 ... Int(numberExampleCycles) {
    let dutyCycle = 1.0 / numberExampleCycles * Double(index)
    guard let _ = try? module.set(channel: redLedChannel, dutyCycle: dutyCycle),
        let _ = try? module.set(channel: yellowLedChannel, dutyCycle: dutyCycle) else {
            fatalError("Failed to set the values for the given channels")
    }
    Thread.sleepForTimeInterval(cycleDuration)
}

// Wait still a bit when duty cycle 100%
Thread.sleepForTimeInterval(3)
