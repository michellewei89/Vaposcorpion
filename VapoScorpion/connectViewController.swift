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
    
    private func connect(accessory: EAAccessory){
        
        let connection: Ev3Connection? = Ev3Connection(accessory: accessory)
        let brick: Ev3Brick? = Ev3Brick(connection: connection!)
        connection?.open()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let complete : EABluetoothAccessoryPickerCompletion? = nil
        EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: nil, completion: complete)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(accessoryConnected), name: EAAccessoryDidConnectNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(accessoryDisconnected), name: EAAccessoryDidDisconnectNotification, object: nil)
        EAAccessoryManager.sharedAccessoryManager().registerForLocalNotifications()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

