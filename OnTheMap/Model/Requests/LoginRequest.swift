//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/12/21.
//

import Foundation

struct UserLogin: Encodable {
    
    let udacity: LoginRequest
    
    enum CodingKeys: String, CodingKey {
        case udacity = "udacity"
    }
}
struct LoginRequest: Encodable {
    
    let username: String
    let password: String
    
}
