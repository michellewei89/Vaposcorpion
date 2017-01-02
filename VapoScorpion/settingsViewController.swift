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
    var brick: Ev3Brick? = nil
    var controlVC : controlViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setDefaultSpeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDefaultSpeed()
    }
    @IBOutlet weak var forwardLabel: UILabel!
    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var tailLabel: UILabel!
    
    @IBOutlet weak var forwardUISlider: UISlider!
    @IBOutlet weak var backUISlider: UISlider!
    
    func setDefaultSpeed() {
        // set slider label texts
        forwardLabel.text = "\(Int(100*forwardUISlider.value))"
        backLabel.text = "\(Int(100*backUISlider.value))"
        //send default speed to EV3
        let barViewControllers = self.tabBarController?.viewControllers
        controlVC = barViewControllers![0] as? controlViewController
        brick = controlVC?.brick //get brick from control view
        if (brick != nil) {
            let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
            command.writeMailbox("forward", value: 100*forwardUISlider.value)
            command.writeMailbox("back", value: 100*backUISlider.value)
        }
    }
    
    @IBAction func forwardSlider(_ sender: UISlider) {
        let currentValue = Int(Float(sender.value)*100)
        forwardLabel.text = "\(currentValue)"

        brick = controlVC?.brick
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
        
        brick = controlVC?.brick
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("back", value: Float(lolValue))

    }
    
    @IBAction func tailSlider(_ sender: UISlider) {
        let theValue = Int(Float(sender.value)*100)
        
        tailLabel.text = "\(theValue)"

    }
}

