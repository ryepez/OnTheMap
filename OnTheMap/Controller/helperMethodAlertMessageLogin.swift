//
//  helperMethodAlertMessageLogin.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/20/21.
//

import Foundation

//helper method to show different alert depending on the error
func helperToDisplayAlertForLogin(errorString: Error) -> String {
    
    
    var messageForUser: String
    
    enum loginMessage: String {
        
        case wrongCredential = "The data couldn’t be read because it isn’t in the correct format."
        
        var stringValue: String {
            switch self {
            
            case .wrongCredential:
                return "You have entered an invalid username or password."
                
            }
        }
        var message: String {
            return stringValue
        }
        
    }
    
    if let message = loginMessage.init(rawValue: errorString.localizedDescription.description) {
        messageForUser = message.stringValue
        
    } else {
        messageForUser = errorString.localizedDescription.description
    }
    
    return messageForUser
}

