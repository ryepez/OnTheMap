//
//  StudentPostErrorResponse.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/16/21.
//

import Foundation


struct PostError: Codable {
    
    let code: Int
    let error: String
}

extension PostError: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
