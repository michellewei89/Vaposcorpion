//
//  settingsViewController.swift
//  VapoScorpion
//
//  Created by Michelle Wei on 12/21/16.
//  Copyright © 2016 Michelle Wei. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        var currentValue = Float(sender.value)
        
        forwardLabel.text = "\(currentValue)"
    }

    @IBAction func liftSlider(_ sender: UISlider) {
        var yayValue = Float(sender.value)
        
        liftLabel.text = "\(yayValue)"

    }
    
    @IBAction func backSlider(_ sender: UISlider) {
        var lolValue = Float(sender.value)
        
        backLabel.text = "\(lolValue)"

    }
    
    @IBAction func tailSlider(_ sender: UISlider) {
        var theValue = Float(sender.value)
        
        tailLabel.text = "\(theValue)"

    }
}

