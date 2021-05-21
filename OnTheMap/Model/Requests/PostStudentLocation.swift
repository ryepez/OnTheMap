//
//  PostStudentLocation.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/16/21.
//

import Foundation

struct StudentLocationPost: Encodable {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
}


