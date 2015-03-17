//
//  ViewController.swift
//  tips
//
//  Created by Ali Danish Rizvi on 3/4/15.
//  Copyright (c) 2015 rizview. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tip_percent_label: UILabel!
    @IBOutlet weak var tip_amount_label: UILabel!
    @IBOutlet weak var bill_amount_label: UITextField!
    @IBOutlet weak var total_amount_label: UILabel!
    @IBOutlet weak var split_amount_label: UILabel!
    
    @IBOutlet weak var split_count_label: UILabel!
    @IBOutlet weak var tip_slider: UISlider!
    @IBOutlet weak var split_slider: UISlider!

    @IBOutlet weak var split_image: UIImageView!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    var smiley = UIImage(named: "smiley_icon.png")
    var scissor = UIImage(named: "scissor_icon.png")
    
    var tip_percent_value:Int = 18
    var split_count_value:Int = 1
    var total_value:Double = 0.0
    var per_head_value:Double = 0.0
    
    //default Settings (for first time)
    var max_tip_percent = 30
    var max_person_count = 8
    var split_bill:Bool = true
    
    func loadSettings()
    {
        println(" Reload Settings ")
        //Load the last saved settings state
        var defaults = NSUserDefaults.standardUserDefaults()
        max_tip_percent = defaults.integerForKey("tip_percent")
        max_person_count = defaults.integerForKey("person_count")
        split_bill = defaults.boolForKey("split_bill")
        
        //rescale the tip slider
        tip_slider.minimumValue = 0
        tip_slider.maximumValue = Float(max_tip_percent)
        tip_slider.setValue(Float(tip_percent_value), animated:true)
        
        //rescale the person count slider
        split_slider.minimumValue = 1
        split_slider.maximumValue = Float(max_person_count)
        split_slider.setValue(Float(split_count_value), animated:true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println("loading started ...")
        resetAppState()
        
        tip_slider.setThumbImage(smiley, forState:UIControlState.Normal)
        split_slider.setThumbImage(scissor, forState:UIControlState.Normal)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUIApplicationDidEnterBackground"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUIApplicationWillEnterForegroundNotification"), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        println("loading finished")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        //TBD
    }

    //user input via keyboard
    @IBAction func OnEditingChanged(sender: AnyObject) {
        
        var bill_value:Double = (bill_amount_label.text as NSString).doubleValue
        
        var tip_value:Double = (bill_value * Double(tip_percent_value)) / 100

        total_value = tip_value + bill_value
        
        tip_amount_label.text = String(format: "$ %.2f",tip_value)
        total_amount_label.text = String(format: "$ %.2f",total_value)
        onSplitSliderChange(self)
        
    }
    
    //tip slider
    @IBAction func onValueChanged(sender: AnyObject) {
        
        //println("slider value = \(tip_slider.value)")
        tip_percent_value =  Int(tip_slider.value)
        tip_percent_label.text = "\(tip_percent_value)%"
        
        OnEditingChanged(self)
        
    }
    
    //split slider
    @IBAction func onSplitSliderChange(sender: AnyObject) {
        split_count_value = Int(split_slider.value)
        
        //redundant but to be safe
        if(split_count_value <= 0)
        { split_count_value = 1 }
        
        split_count_label.text = "\(split_count_value)"
        
        per_head_value = total_value / Double(split_count_value)
        
        split_amount_label.text = String(format: "$ %.2f",per_head_value)
        
    }
    
    //hide the keyboard, if screen is touched anywhere
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    //first time or return from setting
    override func viewWillAppear(animated: Bool) {
        
        loadSettings()

    }
    
    //Application in background
    func onUIApplicationDidEnterBackground() {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(CFAbsoluteTimeGetCurrent(),forKey:"exitTime")
        defaults.synchronize()
        
    }
    
    //reset application state if it was started after a long time
    func onUIApplicationWillEnterForegroundNotification() {
        
        //current values
        var defaults = NSUserDefaults.standardUserDefaults()
        var exitTime = defaults.objectForKey("exitTime") as CFAbsoluteTime
        let elapsedTime = CFAbsoluteTimeGetCurrent() - exitTime
        
        //other way
        //let elapsedTime = NSDate().timeIntervalSinceDate(exitTime)
        
        //reset application state after a long time
        if(elapsedTime > 60) {
            
            println("resetting app state")
            
            //reset to default
            resetAppState()
        }
    }
    
    func resetAppState() {
        //reset to default
        tip_percent_value = 18
        split_count_value = 1
        total_value = 0.0
        per_head_value = 0.0
        
        bill_amount_label.text = ""
        tip_amount_label.text = ""
        total_amount_label.text=""
        split_count_label.text = "1"
        split_amount_label.text = ""
        tip_slider.setValue(Float(tip_percent_value), animated:true)
        split_slider.setValue(Float(split_count_value), animated:true)
        
    }
    
    
}

