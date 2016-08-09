# SwiftyPCA9685
Swift classes to control the PCA9685 module and Adafruit 16 channel PWM servo driver breakout.


## Dependencies
To communicate with the PCA9685 or the Adafruit PWM servo boards it's necessary to use I2C protocol. The swift [SMBus library](https://github.com/ccarnino/SMBus-swift) is used by this library as the way to communicate with the module. 

If the app is running on Raspbian, the `I2C` should be enabled via `raspi-config` in `Advanced Options`.

Before beign able to use SMBus in your Swift code, you should install some Linux C libraries.

On a Debian-like distro:

	sudo apt-get install i2c-tools libi2c-dev

Then you have to make sure the i2c module is active. So check or add i2c-dev to /etc/modules. Like:

	# /etc/modules: kernel modules to load at boot time.
	#
	# This file contains the names of kernel modules that should be loaded
	# at boot time, one per line. Lines beginning with  	"#" are ignored.
	
	i2c-dev


## Addresses
On recent Raspberry Pi the *Adafruit PWM breakout* is on the bus number `1`, linux device `/dev/i2c-1`.

The address on the SMBus is the `0x40`. To check, from terminal:

	sudo i2cdetect -y 1


## Compiling
Since the *Swift package manger* still does not work on Raspberry Pi (where I am compiling), the compiler should be informed by the different dependencies to compile.

	swiftc \
	-I ./Packages/SMBus-swift/Packages/Ci2c/ \
	-I ./Packages/SMBus-swift/Packages/CioctlHelper/ \
	./Packages/SMBus-swift/Sources/*.swift \
	Sources/*.swift \
	[YOUR SWIFT SOURCE FILES]

To compile the example app, wich has two LEDs connected to the channel 0 and 1:

	swiftc \
	-I ./Packages/SMBus-swift/Packages/Ci2c/ \
	-I ./Packages/SMBus-swift/Packages/CioctlHelper/ \
	./Packages/SMBus-swift/Sources/*.swift \
	Sources/*.swift \
	Example/PCA9685Module/main.swift


## Contacts
Claudio Carnino, [tugulab.org](http://tugulab.org)
