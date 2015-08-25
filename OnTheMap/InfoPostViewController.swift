//
//  InfoPostViewController.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/18/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import UIKit
import MapKit

class InfoPostViewController: UIViewController, UITextFieldDelegate {
    
    let geocoder: CLGeocoder = CLGeocoder()

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    var objectId: String?
    var oldMapString: String?
    var oldMediaURL: String?
    
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        ParseClient.sharedInstance.queryStudentLocation(UdacityClient.sharedInstance.userID!) { results, error in
            if let locations = results {
                if locations.count > 0 {
                    self.objectId = locations[0].objectId
                    self.oldMapString = locations[0].mapString
                    self.oldMediaURL = locations[0].mediaURL
                    
                    let alert = UIAlertController(title: "Update?", message: "You already have a pin on the map do you want to update it?", preferredStyle: .Alert)
                    let updateAction = UIAlertAction(title: "Update", style: .Default) { (action) in
                        self.entryField.text = self.oldMapString
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alert.addAction(updateAction)
                    alert.addAction(cancelAction)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    //All clear go a head and create a new one
                }
            } else {
                println(error)
            }
            
        }
    }

    @IBAction func submit(sender: AnyObject) {
        entryField.endEditing(false)
        
        if mapString == nil {
            findOnMap(entryField.text)
        } else {
            if let url = NSURL(string: entryField.text) {
                mediaURL = entryField.text
                
                let locationData: [String: AnyObject] = [
                    ParseClient.JSONResponseKeys.uniqueKey: UdacityClient.sharedInstance.userID!,
                    ParseClient.JSONResponseKeys.firstName: UdacityClient.sharedInstance.name!.first,
                    ParseClient.JSONResponseKeys.lastName: UdacityClient.sharedInstance.name!.last,
                    ParseClient.JSONResponseKeys.mapString: mapString!,
                    ParseClient.JSONResponseKeys.mediaURL: mediaURL!,
                    ParseClient.JSONResponseKeys.latitude: latitude!,
                    ParseClient.JSONResponseKeys.longitude: longitude!
                ]
                
                if let id = objectId{
                    ParseClient.sharedInstance.putStudentLocation(id, data: locationData) { success, errorMessage in
                        if success {
                            println("User location updated")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            println(errorMessage)
                        }
                    }
                } else {
                    ParseClient.sharedInstance.postStudentLocation(locationData) { success, errorMessage in
                        if success {
                            println("User location saved")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            println(errorMessage)
                        }
                    }
                }
                
            } else {
                println("Please enter a valid URL")
            }
        }
    }
    
    @IBAction func cancelSubmission(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func findOnMap(location: String) {
        activityIndicator.startAnimating()
        geocoder.geocodeAddressString(location) { placemarks, error in
            if error == nil {
                if let placemark = placemarks[0] as? CLPlacemark {
                    let coordinates = placemark.location.coordinate
                    
                    //Setup data for submission
                    self.latitude = coordinates.latitude as Double
                    self.longitude = coordinates.longitude as Double
                    self.mapString = location
                    
                    let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.5, 0.5))
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                    self.mapView.addAnnotation(annotation)
                    
                    //Reconfigure display
                    dispatch_async(dispatch_get_main_queue()) {
                        self.activityIndicator.stopAnimating()
                        
                        
                        self.topLabel.text = "What is your link?"
                        
                        if self.oldMediaURL != nil {
                            self.entryField.text = self.oldMediaURL
                        } else {
                            self.entryField.text = "Enter URL"
                        }
                        self.submitButton.setTitle("Submit", forState: .Normal)
                        
                        self.mapView.alpha = 1.0
                        self.mapView.setRegion(region, animated: true)
                    }
                }
            } else {
                let alert = UIAlertController(title: "Can't get there from here.", message: "Sorry we couldn't find that location.", preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.entryField.text = ""
                    self.activityIndicator.stopAnimating()
                }
                alert.addAction(dismissAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        submit(self)
        return true
    }
}
