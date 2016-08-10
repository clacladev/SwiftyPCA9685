//
//  main.swift
//  SwiftyPCA9685
//
//  Created by Claudio Carnino on 09/08/2016.
//  Copyright © 2016 Tugulab. All rights reserved.
//

import Glibc


print("Reset all channels")

// Initialize the module and reset all the channels
guard let smBus = try? SMBus(busNumber: 1),
    let module = try? PCA9685Module(smBus: smBus, address: 0x40),
    let _ = try? module.resetAllChannels() else {
        fatalError("Failed to reset all the channels")
}
