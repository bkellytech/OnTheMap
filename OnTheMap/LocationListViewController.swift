//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/18/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var locations: [ParseStudentLocation] = [ParseStudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        ParseClient.sharedInstance.getStudentLocations() { locations, error in
            if locations != nil {
                self.locations = locations!
            } else {
                println("ERROR:")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentLocationCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        
        let location = locations[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
                
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
