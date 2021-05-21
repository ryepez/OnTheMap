//
//  LoginError.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/13/21.
//

import Foundation


struct LoginError: Codable {
    
    let status: Int
    let error: String
}


extension LoginError: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
