//
//  AddNewPinViewController.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/11/21.
//

import UIKit
import CoreLocation


class AddNewPinViewController: UIViewController {
    
    var hasStudentPosted = Bool()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var websiteString: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        // Do any additional setup after loading the view.
        print(hasStudentPosted)
    }
    
    @objc func cancel() {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func findLocation(_ sender: UIButton) {
        //setting the activity indicator to true
        activityRequest(true)
        //function shows user warning if they have not added a website.
        let websiteStringText = pleaseDontAddData(textfield: websiteString)
        
        let address = cityTextField.text!
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location
            else {
                //alert if request fails
                self.pleaseSelectLocation()
                return
            }
            let lat = location.coordinate.latitude
            let log = location.coordinate.longitude
            
            let locationName = CLLocation(latitude: lat, longitude: log)
            
            geoCoder.reverseGeocodeLocation(locationName) { (placemarks, error) in
                
                guard let cityName = placemarks?.first?.locality,
                      let stateName = placemarks?.first?.administrativeArea,
                      let countryName = placemarks?.first?.country
                else {
                    //alert if request fails
                    self.pleaseSelectLocation()
                    return}
                //setting the activity indicator to false
                self.activityRequest(false)
                
                self.preformSegueMap(lat: lat, log: log, cityName: cityName, stateName: stateName, countryName: countryName, websiteString: websiteStringText)
            }
            
            
        }
        
        
    }
    //method that check if website is textfield is emply and post alert
    func pleaseDontAddData(textfield: UITextField) -> String {
        
        let texto: String
        
        if textfield.text == "" {
            let alert = UIAlertController(title: "Please add a website to continue", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        texto = textfield.text!
        
        return texto
    }
    
    func pleaseSelectLocation()  {
        let alert = UIAlertController(title: "Geocoding Failed", message: "Try a new location or try later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func preformSegueMap(lat: Double, log: Double, cityName:String, stateName: String, countryName: String, websiteString: String) {
        
        let nameLocation = "\(cityName), \(stateName), \(countryName)"
        
        
        let DetailVC: LocationMapViewController
        DetailVC = storyboard?.instantiateViewController(withIdentifier: "LocationMapViewController") as! LocationMapViewController
        
        //sending the select image to DetailVC
        
        NetworkRequests.Auth.latitude = lat
        NetworkRequests.Auth.longitude = log
        NetworkRequests.Auth.location = nameLocation
        NetworkRequests.Auth.mediaURL = "http://" + websiteString
        
        navigationController?.pushViewController(DetailVC, animated: true)
        
        
    }
    
    func activityRequest(_ activityRequest: Bool) {
        
        activityRequest ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    
}
