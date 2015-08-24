//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/23/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locations: [ParseStudentLocation] = [ParseStudentLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        ParseClient.sharedInstance.getStudentLocations() { locations, error in
            if locations != nil {
                self.locations = locations!
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                //Display error message
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    
                }
                alert.addAction(dismissAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func addPin(sender: AnyObject) {
        let infoPostController = self.storyboard?.instantiateViewControllerWithIdentifier("InfoPostViewController") as! InfoPostViewController
        
        self.presentViewController(infoPostController, animated: true, completion: nil)
    }
    
    @IBAction func logOut(sender: AnyObject) {
        UdacityClient.sharedInstance.logout() { success, error in
            if success == true {
                dispatch_async(dispatch_get_main_queue()) {
                    let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    
                }
                alert.addAction(dismissAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentLocationCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        
        let location = locations[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = locations[indexPath.row]
        
        let app = UIApplication.sharedApplication()
        if let url = NSURL(string: location.mediaURL) {
             app.openURL( url )
        } else {
            println("ERROR: Invalid url")
        }
    }
    
}
