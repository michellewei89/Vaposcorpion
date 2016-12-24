//
//  Ev3SimpleSounds.swift
//  EV3BTSpike
//
//  Created by Andre on 17.05.16.
//  Copyright © 2016 Andre. All rights reserved.
//

import Foundation

open class Ev3SimpleSounds {


    open static func appendSimpleStartupSound(_ command: Ev3Command, volume: UInt8){
        command.playTone(volume, frequency: 262, duration: 150)
        command.soundReady()
        command.playTone(volume, frequency: 330, duration: 150)
        command.soundReady()
        command.playTone(volume, frequency: 392, duration: 150)
        command.soundReady()
        command.playTone(volume, frequency: 523, duration: 300)
    }
}
