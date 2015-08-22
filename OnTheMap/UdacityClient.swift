//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/22/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    //Singleton
    static let sharedInstance = UdacityClient()
    
    override init() {
        super.init()
    }
    

    func login() {
        let urlString = Constants.BaseURL + Methods.Session
        let URL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"udacity@login.com\", \"password\": \"*********\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let trimmedData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: trimmedData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    func getUserData(userID: String) {
        let urlString = Constants.BaseURL + Methods.User + userID
        let URL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let trimmedData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: trimmedData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    func logout() {
        let urlString = Constants.BaseURL + Methods.Session
        let URL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let trimmedData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: trimmedData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
}
