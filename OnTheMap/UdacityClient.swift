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
    
    override init() {
        super.init()
    }
    
    func requestForMethod( method: String ) -> NSMutableURLRequest {
        let urlString = Constants.BaseURL + method
        let URL = NSURL(string: urlString)!
        return NSMutableURLRequest(URL: URL)
    }
    
    func taskWithRequest( request: NSURLRequest, completionHandler: (results: AnyObject?, error: NSError?) -> Void ) -> NSURLSessionTask {
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest( request ) { (data, response, error) in
            if error == nil {
                //Success
                let trimmedData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                ClientUtility.parseJSONWithCompletionHandler(trimmedData, completionHandler: completionHandler)
            } else {
                //Error
                completionHandler(results: nil, error: error)
            }
        }
        task.resume()
        return task
    }
    

    func loginWithUsername(username: String, password: String, completionHandler: (success: Bool, errorMessage: String?) -> Void ) {
        let request = requestForMethod(Methods.Session)
        
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        taskWithRequest( request ) { result, error in
            if error == nil {
                if let account = result!.valueForKey("account") as? NSDictionary {
                    if let userID = account.valueForKey("key") as? String {
                        self.userID = userID
                        completionHandler(success: true, errorMessage: nil)
                    } else {
                        completionHandler(success: false, errorMessage: Messages.loginError)
                    }
                } else {
                    completionHandler(success: false, errorMessage: Messages.loginError)
                }
            } else {
                completionHandler(success: false, errorMessage: Messages.networkError)
            }
        }
    }
    
    func logout( completionHandler: (success: Bool, errorMessage: String?) -> Void ) {
        let request = requestForMethod(Methods.Session)
        
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        taskWithRequest(request) { result, error in
            if error == nil {
                self.userID = nil
            } else {
                completionHandler(success: false, errorMessage: Messages.networkError)
            }
        }
    }
    
    func getUserData(userID: String, completionHandler: (success: Bool, errorMessage: String?) -> Void ) {
        let request = requestForMethod(Methods.User + userID)
        
        request.HTTPMethod = "GET"
        
        taskWithRequest(request) { result, error in
            if error == nil {
                println("Success")
            } else {
                completionHandler(success: false, errorMessage: Messages.networkError)
            }
        }

    }
    
}
