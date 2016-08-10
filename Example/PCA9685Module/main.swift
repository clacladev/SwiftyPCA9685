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

// Initialize the communication bus
guard let smBus = try? SMBus(busNumber: 1) else {
    fatalError("It has not been possible to open the System Managed/I2C bus")
}

// Initialize the module and led channels
guard let module = try? PCA9685Module(smBus: smBus, address: 0x40),
    let _ = try? module.set(pwmFrequency: 1000),
    let redLedChannel = PCA9685Module.Channel(rawValue: 0),
    let yellowLedChannel = PCA9685Module.Channel(rawValue: 1) else {
        fatalError("Failed to setup the module or the led channels")
}

defer {
    // Reset the module
    guard let _ = try? module.write(channel: redLedChannel, dutyCycle: 0.0),
        let _ = try? module.write(channel: yellowLedChannel, dutyCycle: 0.0),
        let _ = try? module.softReset() else {
            fatalError("Failed to reset the module")
    }
}

let exampleDuration: TimeInterval = 5.0
let cycleDuration: TimeInterval = 0.01
let numberExampleCycles = exampleDuration / cycleDuration

// Fade the leds in
for index in 0 ... Int(numberExampleCycles) {
    
    let dutyCycle = 1.0 / numberExampleCycles * Double(index)
    guard let _ = try? module.write(channel: redLedChannel, dutyCycle: dutyCycle),
        let _ = try? module.write(channel: yellowLedChannel, dutyCycle: dutyCycle) else {
            fatalError("Failed to set the values for the given channels")
    }
    
    guard let readDutyCycle = try? module.readDutyCycle(channel: redLedChannel) else {
        fatalError("Failed to read the values for a given channel")
    }
    print("Set \(dutyCycle * 100.0)% duty cycle. Read \(readDutyCycle * 100.0)% duty cycle.")
    
    Thread.sleepForTimeInterval(cycleDuration)
}

// Wait still a bit when duty cycle 100%
Thread.sleepForTimeInterval(3)
