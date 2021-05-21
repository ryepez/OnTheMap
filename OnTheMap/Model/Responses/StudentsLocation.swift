//
//  StudentsLocation.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/13/21.
//

import Foundation

struct StudentsLocation: Codable {
    
    
    
    let results: [StudentProperties]
    
}

struct StudentProperties: Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
