//
//  InfoPostViewController.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/18/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import UIKit
import MapKit

class InfoPostViewController: UIViewController {
    
    let geocoder: CLGeocoder = CLGeocoder()

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var newLocation: Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        ParseClient.sharedInstance.queryStudentLocation("3778758647") { results, error in
            if let locations = results {
                if locations.count > 0 {
                    self.newLocation = false;
                    println("You have already created a location would you like to overwrite it?")
                } else {
                    //All clear go a head and create a new one
                }
            } else {
                println(error)
            }
            
        }
    }

    @IBAction func submit(sender: AnyObject) {
        if mapString == nil {
            findOnMap(entryField.text)
        } else {
            if let url = NSURL(string: entryField.text) {
                mediaURL = entryField.text
                println("Success")
            } else {
                println("Please enter a valid URL")
            }
            postLocation()
        }
    }
    
    func findOnMap(location: String) {
        geocoder.geocodeAddressString(location) { placemarks, error in
            if error == nil {
                if let placemark = placemarks[0] as? CLPlacemark {
                    let coordinates = placemark.location.coordinate
                    
                    
                    //Setup data for submission
                    self.latitude = coordinates.latitude as Double
                    self.longitude = coordinates.longitude as Double
                    self.mapString = location
                    
                    //Reconfigure display
                    dispatch_async(dispatch_get_main_queue()) {
                        self.mapView.hidden = false
                        self.topLabel.text = "What is your link?"
                        self.entryField.text = "Enter URL"
                    }
                }
            } else {
                println("Error: Couldn't find location")
            }
        }
    }
    
    func postLocation() {
        
    }
    


}
