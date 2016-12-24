//
//  Ev3SystemCommand.swift
//  EV3BTSpike
//
//  Created by Andre on 26.04.16.
//  Copyright © 2016 Andre. All rights reserved.
//

import Foundation

/// System Commands for Ev3 (e.g. file handling)
class Ev3SystemCommand  {
    
    let brick: Ev3Brick
    
    init(brick: Ev3Brick){
        self.brick = brick
    }
    /********* Michelle ***********/
    open func writeMailbox(_ title: String, value: UInt32) {
        let c = Ev3Command(commandType: .systemNoReply)
        c.writeMailbox(title, value: value)
        brick.sendCommand(c)
    }
    open func writeMailbox(_ title: String, value: String) {
        let c = Ev3Command(commandType: .systemNoReply)
        c.writeMailbox(title, value: value)
        brick.sendCommand(c)
    }

}
