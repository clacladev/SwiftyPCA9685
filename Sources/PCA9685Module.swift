//
//  PCA9685Module.swift
//  SwiftyPCA9685
//
//  Created by Claudio Carnino on 09/08/2016.
//  Copyright © 2016 Tugulab. All rights reserved.
//


/// PCA9685 Module
public class PCA9685Module {
    
    /// Module PWM channels
    public enum Channel: Int {
        case channelNo0 = 0
        case channelNo1
        case channelNo2
        case channelNo3
        case channelNo4
        case channelNo5
        case channelNo6
        case channelNo7
        case channelNo8
        case channelNo9
        case channelNo10
        case channelNo11
        case channelNo12
        case channelNo13
        case channelNo14
        case channelNo15
    }
    
    public enum ModuleError: Error {
        case InvalidStartStepValues
        case InvalidDutyCyclePercentageValue
        case FailedToWriteToChannel
    }
    
    /// System Managed Bus/i2c bus through which the communciation happens
    public let smBus: SMBus
    /// Address of the module. Usually expressed as hexadecimal, e.g. 0x40. Use i2cdetect to find the right address
    public let address: Int32
    
    private let numberInitialReservedAddresses = 6
    private let numberAddressesPerChannel = 4
    
    /// Valid steps range
    public let validStepsRange = 0 ..< 4096
    
    
    /// Initialise the module
    /// param smBus SMBus on which the communication happens
    /// param address I2C module address
    public init(smBus: SMBus, address: Int) {
        self.smBus = smBus
        self.address = Int32(address)
    }
    
    
    /// Start address number for a given channel
    /// param channel Channel
    /// return Start address number
    func startAddressNumber(forChannel channel: Channel) -> UInt8 {
        let addressNumber = numberInitialReservedAddresses + (channel.rawValue * numberAddressesPerChannel)
        return UInt8(addressNumber)
    }
    
}


// MARK: - Writing

extension PCA9685Module {

    /// Write on a given channel the on-state start step and off-state start step.
    /// A cycle is composed by 4096 (12 bit) steps.
    /// param channel Channel to set
    /// param onStartStep ON state starts at step no.
    /// param offStartStep OFF state starts at step no.
    public func set(channel: Channel, onStartStep: Int, offStartStep: Int) throws {
        
        guard validStepsRange.contains(onStartStep) && validStepsRange.contains(offStartStep) else {
            throw ModuleError.InvalidStartStepValues
        }
        
        let channelStartAddress = self.startAddressNumber(forChannel: channel)
        
        let onFirstRegistryValue = UInt8(UInt16(onStartStep) & UInt16(0xff))
        let onSecondRegistryValue = UInt8(UInt16(onStartStep) >> UInt16(8))
        let offFirstRegistryValue = UInt8(UInt16(offStartStep) & UInt16(0xff))
        let offSecondRegistryValue = UInt8(UInt16(offStartStep) >> UInt16(8))
        
        guard let _ = try? smBus.writeByteData(address: address, command: channelStartAddress, value: onFirstRegistryValue),
            let _ = try? smBus.writeByteData(address: address, command: channelStartAddress + 1, value: onSecondRegistryValue),
            let _ = try? smBus.writeByteData(address: address, command: channelStartAddress + 2, value: offFirstRegistryValue),
            let _ = try? smBus.writeByteData(address: address, command: channelStartAddress + 3, value: offSecondRegistryValue) else {
                throw ModuleError.FailedToWriteToChannel
        }
    }
 
 
    /// Write a duty cycle percentage on a given channel
    /// param channel Channel to set
    /// param dutyCycle Duty cycle percentage (0 to 1)
    public func set(channel: Channel, dutyCycle: Double) throws {
        
        let validDutyCycleRange = 0.0 ... 1.0
        guard validDutyCycleRange.contains(dutyCycle) else {
            throw ModuleError.InvalidDutyCyclePercentageValue
        }
        let offStartStep = dutyCycle * Double(validStepsRange.last!)
        try set(channel: channel, onStartStep: 0, offStartStep: Int(offStartStep))
    }
    
}
