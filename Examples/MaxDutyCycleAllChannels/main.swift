//
//  main.swift
//  SwiftyPCA9685
//
//  Created by Claudio Carnino on 09/08/2016.
//  Copyright © 2016 Tugulab. All rights reserved.
//

import Glibc


print("Set 100% duty cycle on all channels")

// Initialize the module
guard let smBus = try? SMBus(busNumber: 1),
    let module = try? PCA9685Module(smBus: smBus, address: 0x40),
    let _ = try? module.set(pwmFrequency: 1000) else {
        fatalError("Failed to setup the module")
}

// Set the 100% duty cycle on all channels
for channel in PCA9685Module.Channel.channelsList {
    guard let _ = try? module.write(channel: channel, dutyCycle: 1.0) else {
            fatalError("Failed to write the duty cycle")
    }
}
