//
//  LogOutResponse.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/17/21.
//

import Foundation

struct SessionEnd: Codable {
    
    let id: String
    let expiration: String
    
}

struct LogOutResponse: Codable {
   
    let session: SessionEnd
    
}


