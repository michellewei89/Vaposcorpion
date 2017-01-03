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
    public var hasSliderValues : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setSliderDefault()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // resendSliderValues()
    }
    
    @IBOutlet weak var forwardLabel: UILabel!
    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var tailLabel: UILabel!
    
    @IBOutlet weak var forwardUISlider: UISlider!
    @IBOutlet weak var backUISlider: UISlider!
    @IBOutlet weak var tailUISlider: UISlider!
    @IBOutlet weak var liftUISlider: UISlider!
    
    func setSliderDefault() {
        // set slider label texts
        forwardLabel.text = "\(Int(defaultSpeed.forwardSpeed))"
        backLabel.text = "\(Int(defaultSpeed.backSpeed))"
        tailLabel.text = "\(Int(defaultSpeed.tailSpeed))"
        liftLabel.text = "\(Int(defaultSpeed.liftSpeed))"
        hasSliderValues = true
    }
    
    public func resendSliderValues() {
        brick = getBrick()
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("forward", value: Float32(Int(100*forwardUISlider.value)))
        command.writeMailbox("back", value: Float32(Int(100*backUISlider.value)))
        command.writeMailbox("lift", value: Float32(Int(100*liftUISlider.value)))
        command.writeMailbox("tail", value: Float32(Int(100*tailUISlider.value)))
    }
    
    func getBrick() -> Ev3Brick? {
        let barViewControllers = self.tabBarController?.viewControllers
        let vc : controlViewController?  = barViewControllers![0] as? controlViewController
        return vc?.brick
    }
    
    @IBAction func forwardSlider(_ sender: UISlider) {
        let currentValue = Int(Float(sender.value)*100)
        forwardLabel.text = "\(currentValue)"

        brick = getBrick()
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("forward", value: Float(currentValue))

    }

    @IBAction func liftSlider(_ sender: UISlider) {
        let yayValue = Int(Float(sender.value)*100)
        liftLabel.text = "\(yayValue)"
        brick = getBrick()
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("lift", value: Float(yayValue))


    }
    
    @IBAction func backSlider(_ sender: UISlider) {
        let lolValue = Int(Float(sender.value)*100)
        backLabel.text = "\(lolValue)"
        
        brick = getBrick()
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("back", value: Float(lolValue))

    }
    
    @IBAction func tailSlider(_ sender: UISlider) {
        let theValue = Int(Float(sender.value)*100)
        
        tailLabel.text = "\(theValue)"
        brick = getBrick()
        if (brick == nil) {
            return
        }
        let command : Ev3SystemCommand = Ev3SystemCommand(brick : brick!)
        command.writeMailbox("tail", value: Float(theValue))


    }
}

