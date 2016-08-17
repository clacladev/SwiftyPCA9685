//
//  main.swift
//  SwiftyPCA9685
//
//  Created by Claudio Carnino on 09/08/2016.
//  Copyright © 2016 Tugulab. All rights reserved.
//

import Glibc


print("Reset all channels")

do {
    let smBus = try SMBus(busNumber: 1)
    let module = try PCA9685Module(smBus: smBus, address: 0x40)
    try module.resetAllChannels()
    
} catch let error {
    print(error)
}

