//
//  ViewController.swift
//  VapoScorpion
//
//  Created by Michelle Wei on 12/21/16.
//  Copyright © 2016 Nicholas Wei. All rights reserved.
//

import UIKit
import ExternalAccessory


class controlViewController: UIViewController {
    public var connection: Ev3Connection? = nil
    public var brick: Ev3Brick? = nil
    public var connectedEV3 : EAAccessory? = nil

    @IBAction func ConnectButton(_ sender: Any) {
        connectedEV3 = getEv3Accessory()
        if connectedEV3 != nil {
            connect(accessory: connectedEV3!)
            print("EV3 reconnected ")
        } else {
            print("EV3 not connected")
            let complete : EABluetoothAccessoryPickerCompletion? = nil
            EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: nil, completion: complete)
        }
    }
    @IBOutlet weak var startButton: UIButton!
   
    @IBAction func startButton(_ sender: Any) {
        let buttonLabel = (startButton.titleLabel?.text)!
       
        switch buttonLabel {
        case "Set Up":
            startButton.setTitle("Run", for: .normal)
            startButton.backgroundColor = UIColor(red: 0/255.0, green: 201/255.0, blue: 33/255.0, alpha: 1)
        case "Run":
            startButton.setTitle("Start", for: .normal)
        case "Start":
            startButton.setTitle("Step 2", for: .normal)
            
        case "Step 2":
            startButton.setTitle("Step 3", for: .normal)
        case "Step 3":
            startButton.setTitle("Step 4", for: .normal)
        case "Step 4":
            startButton.setTitle("Step 5", for: .normal)
        case "Step 5":
            startButton.setTitle("Set Up", for: .normal)
        default:
            break
    
        }
        
        
        
        if (brick == nil ) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: buttonLabel)
    }
    @IBAction func forwardButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "forward")
    }
    
    
    @IBAction func slowFowardButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        
        let command: Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "slowforward")

    }
    
    @IBAction func backButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "back")
   }
    
    @IBAction func LeftButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "left")
    }
    @IBAction func rightButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "right")
    }
    @IBAction func stopButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("stop", value: "stop")
    }
    @IBAction func sforwardButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "sforward")
    }

    @IBAction func sbackbutton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "sback")
    }
    
    @IBAction func sleftButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "sleft")
    }
    
    @IBAction func srightButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "sright")
    }
    
    @IBAction func liftButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "lift")
    }
    
    @IBAction func sLiftButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "slift")
    }
    
    @IBAction func putdownButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "putdown")
    }
    
    @IBAction func sputdownButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "sputdown")
    }
    
    @IBAction func tailUpButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "tailup")
    }
   
    
    @IBAction func tailDownButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "taildown")
    }
    
    @IBAction func liftStopButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "liftstop")

    }
    
    @IBAction func lForwardButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "lforward")
    }
    
    @IBAction func rForwardButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("control", value: "rforward")
    }
    
    @IBAction func FinishButton(_ sender: Any) {
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("stop", value: "finish")
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
            let alert = UIAlertController(title: "VapoScorpion", message: "EV3 connected!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            setDefaultSpeed()
            return
        }
        connection = Ev3Connection(accessory: accessory)
        brick = Ev3Brick(connection: connection!)
        connection?.open()
        setDefaultSpeed()
        print("EV3 connection successful")
    }

    private func disconnect(){
        print("EAController::EV3 accessoryDisconnected")
        connection = nil
        brick = nil
    }
    
    func setDefaultSpeed() {
        //send default speed to EV3
        if (brick != nil) {
            let barViewControllers = self.tabBarController?.viewControllers
            let vc : settingsViewController?  = barViewControllers![1] as? settingsViewController
            if vc != nil && vc!.hasSliderValues {
                vc!.resendSliderValues()
            } else {
                let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
                command.writeMailbox("forward", value: defaultSpeed.forwardSpeed)
                command.writeMailbox("back", value: defaultSpeed.backSpeed)
                command.writeMailbox("tail", value: defaultSpeed.tailSpeed)
                command.writeMailbox("lift", value: defaultSpeed.liftSpeed)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: NSNotification.Name.EAAccessoryDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDisconnected), name: NSNotification.Name.EAAccessoryDidDisconnect, object: nil)
        EAAccessoryManager.shared().registerForLocalNotifications()
        ConnectButton(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
