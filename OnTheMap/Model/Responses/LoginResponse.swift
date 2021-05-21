//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/12/21.
//

import Foundation

struct Account: Codable {
    
    let registered: Bool
    let key: String
    
}

struct Session: Codable {
    
    let id: String
    let expiration: String
    
}

struct LoginReponse: Codable {
    
    let account: Account
    let session: Session
}


