//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/22/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        static let BaseURL : String = "https://www.udacity.com/api/"
    }
    
    struct Methods {
        static let Session = "session"
        static let User = "users/"
    }
    
    struct Messages {
        static let loginError = "Udacity Login failed. Incorrect username or password"
        static let networkError = "Error connecting to Udacity."
    }
    
}