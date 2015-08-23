//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/6/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logIn(sender: AnyObject) {
        UdacityClient.sharedInstance.loginWithUsername( usernameField.text, password: passwordField.text) { (success, error) in
            
            if success {
                //Move to TabBarController
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapTabBarController") as! UITabBarController
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            } else {
                //Display error message
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                }
                alert.addAction(dismissAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }

}

