//
//  RegistrationViewController.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/10/21.
//

import UIKit
import WebKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var weView: WKWebView!
    override func viewDidLoad() {
      
        
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let request = URLRequest(url: URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com")!)
        
        weView.load(request)
        
    }
    

}
