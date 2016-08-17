//
//  main.swift
//  SwiftyPCA9685
//
//  Created by Claudio Carnino on 17/08/2016.
//  Copyright © 2016 Tugulab. All rights reserved.
//

import Foundation


extension CommandLine {
    
    /// Structs who holds
    struct AppArguments {
        let busNumber: Int
        let address: Int
        let frequency: Int
        let channel: PCA9685Module.Channel
        let dutyCycle: Double
    }
    
    private enum ArgumentName: String {
        case busNumber = "bus-number"
        case address
        case frequency
        case channel
        case dutyCycle = "duty-cycle"
        
        static var list: [ArgumentName] {
            return [.busNumber, .address, .frequency, .channel, .dutyCycle]
        }
    }
    
    
    /// Returns a dictionary of the app arguments and the respective value set
    static func appArguments() -> AppArguments? {
        
        var commandLineArguments = [ArgumentName: Any]()
        
        // Look for all valid arguments in the input array
        ArgumentName.list.forEach { appArgument in
            for commandLineArgument in CommandLine.arguments {
                
                let argumentPrefix = "\(appArgument.rawValue)="
                let doesItemContainsAppArgumentPrefix = commandLineArgument.contains(argumentPrefix)
                if doesItemContainsAppArgumentPrefix {
                    
                    guard let equalSymbolIndex = commandLineArgument.characters.index(of: "=") else {
                        continue
                    }
                    let valueStartIndex = commandLineArgument.index(after: equalSymbolIndex)
                    let argumentValue = commandLineArgument.substring(from: valueStartIndex)
                    guard !argumentValue.isEmpty else {
                        continue
                    }
                    
                    // Cast the argument value depending on the argument
                    switch appArgument {
                    case .busNumber:
                        commandLineArguments[.busNumber] = Int(argumentValue)
                    case .address:
                        commandLineArguments[.address] = Int(strtoul(argumentValue, nil, 16)) // From hexadecimal string
                    case .frequency:
                        commandLineArguments[.frequency] = Int(argumentValue)
                    case .channel:
                        commandLineArguments[.channel] = Int(argumentValue)
                    case .dutyCycle:
                        commandLineArguments[.dutyCycle] = Double(argumentValue)
                    }
                }
            }
        }
        
        // Check that all the required arguments have been set
        guard let busNumber = commandLineArguments[.busNumber] as? Int,
            let address = commandLineArguments[.address] as? Int,
            let frequency = commandLineArguments[.frequency] as? Int,
            let channelRawValue = commandLineArguments[.channel] as? Int,
            let channel = PCA9685Module.Channel(rawValue: channelRawValue),
            let dutyCycle = commandLineArguments[.dutyCycle] as? Double else {
                return nil
        }
        
        return AppArguments(busNumber: busNumber, address: address, frequency: frequency, channel: channel, dutyCycle: dutyCycle)
    }
    
}
