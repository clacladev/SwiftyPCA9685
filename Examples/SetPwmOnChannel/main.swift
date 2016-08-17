//
//  main.swift
//  SwiftyPCA9685
//
//  Created by Claudio Carnino on 17/08/2016.
//  Copyright © 2016 Tugulab. All rights reserved.
//


// Check that all the app arguments have been correctly set
guard let appArguments = CommandLine.appArguments() else {
    fatalError("The correct way of calling this app is: \npca9685-set-pwm-on-channel bus-number=1 address=0x40 frequency=1000 channel=0 duty-cycle=0.5")
}

do {
    let smBus = try SMBus(busNumber: appArguments.busNumber)
    let module = try PCA9685Module(smBus: smBus, address: appArguments.address)
    try module.set(pwmFrequency: appArguments.frequency)
    try module.write(channel: appArguments.channel, dutyCycle: appArguments.dutyCycle)

} catch let error {
    print(error)
}
