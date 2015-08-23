//
//  Utility.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/22/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import Foundation

class ClientUtility: NSObject {
    
    func taskForGetMethod(
        baseURL: String,
        method: String,
        parameters: [String: AnyObject],
        httpHeaders: [String: AnyObject],
        completionHandler: (result: AnyObject!, error: NSError?) ) -> NSURLSessionDataTask {
        
        let urlString = baseURL + method
            
        return NSURLSessionDataTask()
    }
    
    func taskForPostMethod(
        baseURL: String,
        method: String,
        parameters: [String: AnyObject],
        httpHeaders: [String: AnyObject],
        httpBody: [String:AnyObject],
        completionHandler: (result: AnyObject!, error: NSError?) ) -> NSURLSessionDataTask {
        
        return NSURLSessionDataTask()
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
}
