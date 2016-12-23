//
//  ViewController.swift
//  VapoScorpion
//
//  Created by Michelle Wei on 12/21/16.
//  Copyright © 2016 Michelle Wei. All rights reserved.
//

import UIKit
import ExternalAccessory


class connectViewController: UIViewController {
    var connection: Ev3Connection? = nil
    var brick: Ev3Brick? = nil
    var connectedEV3 : EAAccessory? = nil

    @IBAction func ConnectButton(_ sender: Any) {
        let complete : EABluetoothAccessoryPickerCompletion? = nil
        EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: nil, completion: complete)
        connectedEV3 = getEv3Accessory()
        if connectedEV3 != nil {
            connect(accessory: connectedEV3!)
            print("EV3 reconnected ")
        } else {
            print("EV3 not connected")
        }
    }
    @IBAction func forwardButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3DirectCommand = Ev3DirectCommand(brick : brick!)
        command.playTone(10, frequency: 500, duration: 2000)
    }
    @IBAction func backButton(_ sender: Any) {
    }
    @IBAction func stopButton(_ sender: Any) {
    }
    
    func getEv3Accessory() -> EAAccessory? {
        let man = EAAccessoryManager.shared()
        let connected = man.connectedAccessories
        
        for tmpAccessory in connected{
            if Ev3Connection.supportsEv3Protocol(tmpAccessory){
                return tmpAccessory
            }
        }
        return nil
    }
    
    func accessoryConnected(_ notification: Notification) {
        print("EAController::accessoryConnected")
        
        let connectedAccessory = notification.userInfo![EAAccessoryKey] as! EAAccessory
        
        // check if the device is a ev3
        if !Ev3Connection.supportsEv3Protocol(connectedAccessory) {
            return
        }
        
        connect(accessory: connectedAccessory)
    }
    
    func accessoryDisconnected(notification: Notification) {
        print("EAController::accessoryDisconnected")
        let connectedAccessory = notification.userInfo![EAAccessoryKey] as! EAAccessory
        
        // check if the device is a ev3
        if !Ev3Connection.supportsEv3Protocol(connectedAccessory) {
            return
        }
        
        disconnect()
    }
    
    private func connect(accessory: EAAccessory){
        if connection != nil && !(connection!.isClosed) {
            return
        }
        connection = Ev3Connection(accessory: accessory)
        brick = Ev3Brick(connection: connection!)
        connection?.open()
        print("EV3 connection successful")
    }

    private func disconnect(){
        print("EAController::EV3 accessoryDisconnected")
        connection = nil
        brick = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: NSNotification.Name.EAAccessoryDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDisconnected), name: NSNotification.Name.EAAccessoryDidDisconnect, object: nil)
        EAAccessoryManager.shared().registerForLocalNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

