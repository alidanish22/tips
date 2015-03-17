//
//  ViewControllerSettings.swift
//  tips
//
//  Created by Ali Danish Rizvi on 3/11/15.
//  Copyright (c) 2015 rizview. All rights reserved.
//

import UIKit

class ViewControllerSettings: UIViewController {

    @IBOutlet weak var max_tip_box: UITextField!
    @IBOutlet weak var max_person_box: UITextField!
    @IBOutlet weak var split_bill_switch: UISwitch!
    
    var default_split_bill:Bool = true
    var default_person:Int = 8
    var default_tip_percent:Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Load the last saved settings state
        var defaults = NSUserDefaults.standardUserDefaults()
        var tip_percent = defaults.integerForKey("tip_percent")
        var person_count = defaults.integerForKey("person_count")
        var split_bill = defaults.boolForKey("split_bill")
      
        max_tip_box.text = "\(tip_percent)"
        max_person_box.text = "\(person_count)"
        split_bill_switch.setOn(split_bill, animated: true)
        
        println("Settings::viewDidLoad")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //======  Second view controller actions ==============
    
    
    @IBAction func onSettingsHome(sender: AnyObject) {
        
        let percent:Int? = max_tip_box.text?.toInt()
        var tip_percent = percent ?? default_tip_percent
        
        let person:Int? = max_person_box.text?.toInt()
        var person_count = person ?? default_person
        
        //save setting state
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tip_percent, forKey:"tip_percent")
        defaults.setInteger(person_count, forKey:"person_count")
        defaults.setBool(split_bill_switch.on,forKey:"split_bill")
        
        defaults.synchronize()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
        
    }
}
