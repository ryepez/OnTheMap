//
//  ViewController.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/7/21.
//

import UIKit

class ViewController: UIViewController,  UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var instragramAuthButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUPButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //setting the textfield delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        
    }
    
    
    
    func handleSessionResponse(success: Bool, error: Error?) {
        
        setLoggion(false)
        
        if success {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            //to cHAnge the root view controller calling the object created in scene delegete
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        } else {
            showAlert(alertText: "Login Failed", alertMessage: helperToDisplayAlertForLogin(errorString: error!))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // notifications to key track of the keyboard
        subscribeToKeyboardNotifications()
        subscribeToKeyboardNotificationsHide()
        
        //hide navaigation when return from registration tab 
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //unsubscribe keyboard notifications
        
        unsubscribeToKeyboardNotifications()
        unsubscribeToKeyboardNotificationsHide()
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // when the user press return the keyboard disappear
        textField.resignFirstResponder()
        return true
    }
    
    
    // keyboard Setting
    @objc  func keyboardWiShow(_ notification:Notification) {
        // if statement to only do the movement of keyboard when is the bottom textfield
        if passwordTextField.isEditing || emailTextField.isEditing, view.frame.origin.y == 0  {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    //function that gets the height of the keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat  {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    //keyboard subscriptions
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //hidding keyboard
    
    @objc func keyboardWillHide(_ notification:Notification) {
        //return the view to it is orginal point if the view is not at zero
        
        if  passwordTextField.isEditing || emailTextField.isEditing, view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
        
    }
    
    func subscribeToKeyboardNotificationsHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotificationsHide() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        //setting the activity indicator
        setLoggion(true)
        
        NetworkRequests.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleSessionResponse(success:error:))
        
    }
    
    func setLoggion(_ logingIP: Bool) {
        
        logingIP ? activityIndicator.startAnimating(): activityIndicator.stopAnimating()
        
        emailTextField.isEnabled = !logingIP
        passwordTextField.isEnabled = !logingIP
        loginButton.isEnabled = !logingIP
        signUPButton.isEnabled = !logingIP
        instragramAuthButton.isEnabled = !logingIP
        
    }
    
    
}

