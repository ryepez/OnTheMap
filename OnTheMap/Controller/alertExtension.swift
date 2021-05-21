//
//  alertExtension.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/21/21.
//

import Foundation
import UIKit

extension LocationMapViewController {
    
    func showAlert(alertText : String, alertMessage : String) {
    let alertVC = UIAlertController(title:alertText, message: alertMessage, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    self.present(alertVC, animated: true)
}
}
