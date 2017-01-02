//
//  settingsViewController.swift
//  VapoScorpion
//
//  Created by Michelle Wei on 12/21/16.
//  Copyright © 2016 Michelle Wei. All rights reserved.
//

import UIKit
import ExternalAccessory

class settingsViewController: UIViewController {
    var connection: Ev3Connection? = nil
    var brick: Ev3Brick? = nil
    var connectedEV3 : EAAccessory? = nil
    var controlVC : controlViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let barViewControllers = self.tabBarController?.viewControllers
        controlVC = barViewControllers![0] as? controlViewController
        brick = controlVC?.brick
        connectedEV3 = controlVC?.connectedEV3
        connection = controlVC?.connection
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var forwardLabel: UILabel!
    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var tailLabel: UILabel!
    
    
    
    
    @IBAction func forwardSlider(_ sender: UISlider) {
        let currentValue = Int(Float(sender.value)*100)
        
        forwardLabel.text = "\(currentValue)"
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("forward", value: Float(currentValue))

    }

    @IBAction func liftSlider(_ sender: UISlider) {
        let yayValue = Int(Float(sender.value)*100)
        
        liftLabel.text = "\(yayValue)"

    }
    
    @IBAction func backSlider(_ sender: UISlider) {
        let lolValue = Int(Float(sender.value)*100)
        
        backLabel.text = "\(lolValue)"

    }
    
    @IBAction func tailSlider(_ sender: UISlider) {
        let theValue = Int(Float(sender.value)*100)
        
        tailLabel.text = "\(theValue)"

    }
}

