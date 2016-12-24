//
//  Ev3Brick.swift
//  EV3BTSpike
//
//  Created by Andre on 21.04.16.
//  Copyright © 2016 Andre. All rights reserved.
//

import Foundation

public protocol Ev3BrickChangedDelegate {
    func brickChanged()
}

open class Ev3Brick : Ev3ReportDelegate, Ev3ConnectionChangedDelegate {
    /// Interval for polling brick infos
    fileprivate let timeInterval: TimeInterval = 2.0
    
    /// The connection on which the app can read/write data
    fileprivate let connection: Ev3Connection
    
    fileprivate let alwaysSendEvents: Bool
    
    fileprivate var timer: Timer?
    
    /// Send "direct commands" to the EV3 brick.  These commands are executed instantly and are not batched.
    open var directCommand: Ev3DirectCommand!
    
    /// Send a batch command of multiple direct commands at once.
    open var command: Ev3Command!
    
    /// Send "system commands" to the EV3 brick.  These commands are executed instantly and are not batched.
    var systemCommand: Ev3SystemCommand!
    
    /// Input and output ports on LEGO EV3 brick
    var ports: Dictionary<InputPort, Ev3Port>
    
    /// Buttons on the face of the LEGO EV3 brick
    var buttons: BrickButtons
    
    /// Add delegates to get informed, if the brick has changed
    var brickChangedDelegates = [Ev3BrickChangedDelegate]()
    
    let responseSize = 11

    convenience init(connection: Ev3Connection){
        self.init(connection: connection, alwaysSendEvents: false)
    }
    
    /// Constructor
    /// - parameter comm: Object implementing the Ev3Connection interface for talking to the brick
    /// - parameter alwaysSendEvents: Send events when data changes, or at every poll
    init(connection: Ev3Connection, alwaysSendEvents: Bool){
        self.connection = connection
        self.alwaysSendEvents = alwaysSendEvents
        buttons = BrickButtons()
        ports = [InputPort: Ev3Port]()
        
        directCommand = Ev3DirectCommand(brick: self)
        command = Ev3Command(brick: self)
        systemCommand = Ev3SystemCommand(brick: self)
        
        connection.addEv3ReportDelegate(self)
        connection.connectionChangedDelegates.append(self)
        
        //TODO fix async pooling -> command too big for input stream?
        // schedule the background polling of the input stream
        /*timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(Ev3Brick.pollSensorsAsync), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)*/
        
        addAllPorts()
    }
    
    fileprivate func addAllPorts(){
        
        for port in InputPort.allValues {
            let p = Ev3Port()
            p.index = InputPort.allValues.index(of: port)
            p.inputPort = port
            
            //TODO set name
            
            ports.updateValue(p, forKey: port)
        }
  
    }
    
    open func ev3ConnectionChanged(_ connected: Bool){
        if !connected{
            timer?.invalidate()
        }
        else if (timer == nil || !timer!.isValid) {
            
            // schedule new timer
            /*timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(Ev3Brick.pollSensorsAsync), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)*/
        }
    }
    
    func reportReceived(_ report: [UInt8]){
        Ev3ResponseManager.handleResponse(report)
    }
    
    func sendCommand(_ command: Ev3Command){
        connection.write(command)
    }
    
    func closeConnection(){
        connection.close()
    }
    
    // TODO complete async polling
    @objc open func pollSensorsAsync() {
        var index = 0;
        
        let c = Ev3Command(commandType: CommandType.directReply, globalSize: UInt16((8 * responseSize) + 6), localSize: 0)
        
        for port in InputPort.allValues {
            let p = ports[port]
            index = p!.index! * responseSize;
            
            c.getTypeMode(p!.inputPort!, typeIndex: index, modeIndex: index + 1)
            c.readySI(p!.inputPort!, mode: p!.mode, index: index + 2)
            c.readyRaw(p!.inputPort!, mode: p!.mode, index: index + 6)
            c.readyPercent(p!.inputPort!, mode: p!.mode, index: index + 10)
        }        
    
        index += responseSize;
    
        c.isBrickButtonPressed(BrickButton.back,  index: index + 0);
        c.isBrickButtonPressed(BrickButton.left,  index: index + 1);
        c.isBrickButtonPressed(BrickButton.up,    index: index + 2);
        c.isBrickButtonPressed(BrickButton.right, index: index + 3);
        c.isBrickButtonPressed(BrickButton.down,  index: index + 4);
        c.isBrickButtonPressed(BrickButton.enter, index: index + 5);
        
        c.response?.responseReceivedCallback = {
            if c.response?.data != nil {
                self.backgroundDataReceived(c.response!, index)
            }
        }
    
        sendCommand(c);
    }
    
    fileprivate func backgroundDataReceived(_ response: Ev3Response, _ index: Int){
        var changed = false;
        
        for i in InputPort.allValues{
            let p = ports[i]
            
            let type: UInt8 = convertToUInt8(response.data! as Data, position: (p!.index! * responseSize) + 0)
            
            //TODO is mode used?
            //let mode: UInt8 = convertToUInt8(c.response!.data!, position: (p!.index! * responseSize) + 1)
            
            let siValue: Float = convertToFloat(response.data! as Data, position: (p!.index! * responseSize) + 2)
            let rawValue: Int32 = convertToInt32(response.data! as Data, position: (p!.index! * responseSize) + 6)
            
            let percentValue: UInt8 = convertToUInt8(response.data! as Data, position: (p!.index! * responseSize) + 10)
            
            if p!.type?.rawValue != type || abs(p!.siValue! - siValue) > 0.01 || p!.rawValue != rawValue || p!.percentValue != percentValue {
                changed = true
            }
            
            if let t = DeviceType(rawValue: type){
                p!.type = t
            }
            else{
                p!.type = DeviceType.unknown
            }
            
            p!.siValue = siValue
            p!.rawValue = rawValue
            p!.percentValue = percentValue
        }

        
        if buttons.back != (convertToUInt8(response.data! as Data, position: index + 0) == 1) ||
            buttons.left != (convertToUInt8(response.data! as Data, position: index + 1) == 1) ||
            buttons.up != (convertToUInt8(response.data! as Data, position: index + 2) == 1) ||
            buttons.right != (convertToUInt8(response.data! as Data, position: index + 3) == 1) ||
            buttons.down != (convertToUInt8(response.data! as Data, position: index + 4) == 1) ||
            buttons.enter != (convertToUInt8(response.data! as Data, position: index + 5) == 1)
        {
            changed = true
        }
        
        buttons.back = (convertToUInt8(response.data! as Data, position: index + 0) == 1)
        buttons.left = (convertToUInt8(response.data! as Data, position: index + 1) == 1)
        buttons.up = (convertToUInt8(response.data! as Data, position: index + 2) == 1)
        buttons.right = (convertToUInt8(response.data! as Data, position: index + 3) == 1)
        buttons.down = (convertToUInt8(response.data! as Data, position: index + 4) == 1)
        buttons.enter = (convertToUInt8(response.data! as Data, position: index + 5) == 1)
        
        if changed || alwaysSendEvents {
            for del in brickChangedDelegates {
                del.brickChanged()
            }
        }
    }
    
    fileprivate func convertToFloat(_ data: Data, position: Int) -> Float{
        var out: Float = 0
        (data as NSData).getBytes(&out, range: NSMakeRange(position, 4))
        return out
    }
    
    fileprivate func convertToInt32(_ data: Data, position: Int) -> Int32 {
        var out: Int32 = 0
        (data as NSData).getBytes(&out, range: NSMakeRange(position, 4))
        return out
    }
    
    fileprivate func convertToUInt8(_ data: Data, position: Int) -> UInt8{
        var out: UInt8 = 0
        (data as NSData).getBytes(&out, range: NSMakeRange(position, 1))
        return out
    }
}
