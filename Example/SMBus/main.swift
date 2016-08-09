//
//  SMBusExample.swift
//  GPIOSwiftyBlaster
//
//  Created by Claudio Carnino on 05/08/2016.
//  Copyright © 2016 Tugulab. All rights reserved.
//

import Foundation


// Open the bus
guard let bus = try? SMBus(busNumber: 1) else {
    fatalError("It has not been possible to open the I2C bus")
}

for i in 0...10 {
    // Blink the led few times (high/medium brightness)
    try! bus.writeByteData(address: 0x40, command: 0x06, value: 0x00)
    try! bus.writeByteData(address: 0x40, command: 0x07, value: 0x00)
    try! bus.writeByteData(address: 0x40, command: 0x08, value: (i % 2 == 0) ? 0xff : 0x99)
    try! bus.writeByteData(address: 0x40, command: 0x09, value: (i % 2 == 0) ? 0x0f : 0x00)
    
    Thread.sleepForTimeInterval(1)
}

// Turn off the led
try! bus.writeByteData(address: 0x40, command: 0x06, value: 0x00)
try! bus.writeByteData(address: 0x40, command: 0x07, value: 0x00)
try! bus.writeByteData(address: 0x40, command: 0x08, value: 0x00)
try! bus.writeByteData(address: 0x40, command: 0x09, value: 0x00)
