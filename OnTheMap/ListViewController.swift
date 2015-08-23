//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/18/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
