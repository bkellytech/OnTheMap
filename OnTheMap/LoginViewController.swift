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
        println("TASK: Implement login")
        UdacityClient.sharedInstance.loginWithUsername( usernameField.text, password: passwordField.text) { (success, error) in
            
            if success {
                //Move to TabBaController
                dispatch_async(dispatch_get_main_queue()) {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapTabBarController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
                
            } else {
                //Display error message
            }
        }
    }

}

