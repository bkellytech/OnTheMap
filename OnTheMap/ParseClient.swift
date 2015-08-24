//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/23/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    //Singleton
    static let sharedInstance = ParseClient()
    
    override init() {
        super.init()
    }
    

    func requestForMethod( method: String ) -> NSMutableURLRequest {
        let urlString = Constants.BaseURL
        let URL = NSURL(string: urlString)!
        
        return NSMutableURLRequest(URL: URL)
    }
    
    func taskWithRequest( request: NSMutableURLRequest, completionHandler: (results: AnyObject?, error: NSError?) -> Void ) -> NSURLSessionTask {
        
        request.addValue(Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest( request ) { (data, response, error) in
            if error == nil {
                //Success
                ClientUtility.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            } else {
                //Error
                completionHandler(results: nil, error: error)
            }
        }
        task.resume()
        return task
    }

    
    func getStudentLocations( completionHandler: (results: [ParseStudentLocation]?, errorMessage: String?) -> Void ) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseURL)!)
        
        taskWithRequest(request) { JSONresults, error in
            if error == nil {
                if let results = JSONresults?.valueForKey(JSONResponseKeys.results) as? [[String : AnyObject]] {
                    var locations = ParseStudentLocation.locationsFromResults(results)
                    completionHandler( results: locations, errorMessage: nil )
                }
            } else {
                completionHandler( results: nil, errorMessage: Messages.downloadError )
            }
        }
    }
    
    func queryStudentLocation( uniqueKey: String, completionHandler: (results: [ParseStudentLocation]?, errorMessage: String?) -> Void ) {
        
        let urlString = "\(Constants.BaseURL)?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        taskWithRequest(request) { JSONresults, error in
            if error == nil {
                if let results = JSONresults?.valueForKey(JSONResponseKeys.results) as? [[String : AnyObject]] {
                    var locations = ParseStudentLocation.locationsFromResults(results)
                    completionHandler( results: locations, errorMessage: nil )
                }
            } else {
                completionHandler( results: nil, errorMessage: Messages.downloadError )
            }
        }
    }
    
    func postStudentLocation( completionHandler: (success: Bool, errorMessage: String?) -> Void ) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseURL)!)
        
        request.HTTPMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        
        taskWithRequest(request) { JSONresults, error in
            if error == nil {
                completionHandler(success: true, errorMessage: nil)
            } else {
                completionHandler(success: false, errorMessage: Messages.postError)
            }
        }
    }
    
}