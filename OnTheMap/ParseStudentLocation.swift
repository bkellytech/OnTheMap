//
//  ParseStudentLocation.swift
//  OnTheMap
//
//  Created by Kelly Egan on 8/23/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import Foundation

struct ParseStudentLocation {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    
    init( dictionary: [String : AnyObject] ) {
        objectId = dictionary[ParseClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as! Float
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as! Float
    }
    
    static func locationsFromResults(results: [[String : AnyObject]]) -> [ParseStudentLocation] {
        var locations = [ParseStudentLocation]()
        
        for result in results {
            locations.append( ParseStudentLocation(dictionary: result) )
        }
        
        return locations
    }

}