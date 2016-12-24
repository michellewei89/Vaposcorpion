//
//  Ev3Port.swift
//  EV3BTSpike
//
//  Created by Andre on 03.05.16.
//  Copyright © 2016 Andre. All rights reserved.
//

import Foundation


open class Ev3Port {

    var index: Int?
    var inputPort: InputPort?
    
    /// Name of port.
    var name: String?
    
    /// Device plugged into port.
    var type: DeviceType?
    
    /// Device mode.  Some devices work in multiple modes.
    var mode: UInt8 = 0
    
    /// Current International System of Units value associated with the Port.
    var siValue: Float?
    
    /// Raw value associated with the Port.
    var rawValue: Int32?
    
    /// Percentage value associated with the Port.
    var percentValue: UInt8?
    
    //TODO sync
    //private let context: SynchronizationContext
    
    /// Constructor
    public init (){
        
    }
    

    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: UInt8){
        self.mode = mode
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: TouchMode) {
        self.mode = mode.rawValue
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: NxtLightMode) {
        self.mode =	mode.rawValue
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: NxtSoundMode) {
        self.mode = mode.rawValue
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: NxtUltrasonicMode) {
        self.mode = mode.rawValue
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: NxtTemperatureMode) {
        self.mode = mode.rawValue
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: MotorMode) {
        self.mode = mode.rawValue
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: ColorMode) {
        self.mode = mode.rawValue
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: UltrasonicMode){
        self.mode = mode.rawValue
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: GyroscopeMode){
        self.mode = mode.rawValue
    }
    
    /// Set the connected sensor's mode
    /// - parameter mode: The requested mode.
    open func setMode(_ mode: InfraredMode) {
        self.mode = mode.rawValue
    }
    
    
}
