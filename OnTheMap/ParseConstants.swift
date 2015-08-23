//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/23/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import Foundation


extension ParseClient {
    struct Constants {
        static let BaseURL: String = "https://api.parse.com/1/classes/StudentLocation"
        static let AppID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct Messages {
        static let networkError = "Error connecting to Parse."
    }
}