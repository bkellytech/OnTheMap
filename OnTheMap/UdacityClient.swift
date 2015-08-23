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
    
    var userID: String?
    var loggedIn: Bool
    
    override init() {
        loggedIn = false

        super.init()
    }

    func loginWithUsername(username: String, password: String, completionHandler: (success: Bool, errorMessage: String?) -> Void ) {
        let urlString = Constants.BaseURL + Methods.Session
        let URL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorMessage: "Network error occured.")
            } else {
                let trimmedData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                
                ClientUtility.parseJSONWithCompletionHandler(trimmedData) { (result, error) in
                    if let error = error {
                        completionHandler(success: false, errorMessage: error.description)
                    } else {
                        if let account = result.valueForKey("account") as? NSDictionary {
                            if let userID = account.valueForKey("key") as? String {
                                self.userID = userID
                                self.loggedIn = true
                                completionHandler(success: true, errorMessage: nil)
                            } else {
                                completionHandler(success: false, errorMessage: "Login Failed (User ID).")
                            }
                        } else {
                            completionHandler(success: false, errorMessage: "Login Failed (User ID).")
                        }
                    }
                }
            }
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
            self.userID = nil
            self.loggedIn = false
            println(NSString(data: trimmedData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
}
