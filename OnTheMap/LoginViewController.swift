//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/6/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginSubview: UIView!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    let shake = CAKeyframeAnimation( keyPath:"transform" )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        shake.values = [
            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        shake.autoreverses = true
        shake.repeatCount = 2
        shake.duration = 7/100
    }
    
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.hidesWhenStopped = true
        self.passwordField.text = ""
    }

    @IBAction func logIn(sender: AnyObject) {
        startNetworkActivity()
        passwordErrorLabel.hidden = true
        
        UdacityClient.sharedInstance.loginWithUsername( usernameField.text, password: passwordField.text) { (success, error) in
            
            if success {
                //Move to TabBarController
                dispatch_async(dispatch_get_main_queue()) {
                    self.stopNetworkActivity()
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapTabBarController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            } else {
                //Display error message
                
                if error == UdacityClient.Messages.loginError {
                    //Incorrect username or password
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loginSubview.layer.addAnimation( self.shake, forKey:nil )
                        self.passwordErrorLabel.hidden = false
                    }
                    
                    self.passwordField.text = ""
                } else {
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alert.addAction(dismissAction)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.stopNetworkActivity()
                }
            }
        }
    }
    
    func startNetworkActivity() {
        activityIndicator.startAnimating()
        loginButton.hidden = true
        usernameField.userInteractionEnabled = false
        passwordField.userInteractionEnabled = false
    }
    
    func stopNetworkActivity() {
        activityIndicator.stopAnimating()
        loginButton.hidden = false
        usernameField.userInteractionEnabled = true
        passwordField.userInteractionEnabled = true
    }

}

