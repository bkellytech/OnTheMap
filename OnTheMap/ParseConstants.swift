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
    
    struct JSONResponseKeys {
        //GET and QUERY
        static let results: String = "results"
        
        static let objectId: String = "objectId"
        static let uniqueKey: String = "uniqueKey"
        static let firstName: String = "firstName"
        static let lastName: String = "lastName"
        static let mapString: String = "mapString"
        static let mediaURL: String = "mediaURL"
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
        
        //POST
        static let createdAt: String = "createdAt"
        
        //PUT
        static let updatedAt: String = "updatedAt"
    }
}