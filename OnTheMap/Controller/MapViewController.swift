//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/9/21.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    var hasStudentPosted = Bool()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        
        // Get the student location of the 100 recent updated and saving the data in a class called DataModel
        
        NetworkRequests.getStudentLocation {
            (studentLocation, error) in
            //if statement to check if data was return else display an alert message 
            if studentLocation.count != 0 {
                //saving the data on data object
                DataModel.studentLocations = studentLocation
                //checking if the student has posted already and setting that variable in the Aut Struct
                self.hasStudentPosted = NetworkRequests.checkIfStudentPostedAlready()
                NetworkRequests.Auth.checkIfStudentPostedAlready = NetworkRequests.checkIfStudentPostedAlready()
                //calling a helper method that formats the data in the way that map can use and adding the data to map
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(StudentDataForMapAndTable.studentFormatedData())
            } else {
                //if unable to download the data print message
                let alertVC = UIAlertController(title: "Failure to Download Student Locations", message: "Please try again later", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alertVC, animated: true)
            }
            
        }
        
        
        // network request to get objectId if the student has posted before
        NetworkRequests.getStudentOne { (response, error) in
            if let respuesta = response.first?.objectId {
                // saving the objectId in to Auth struct
                NetworkRequests.Auth.objectId = respuesta
            } else {
                print("No objectID found")
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    // MARK: UI Button methods
    @IBAction func LogginOut(_ sender: UIButton) {
        
        //calling loginOut function to logout
        NetworkRequests.logDelete(completion: handleSessionDelete(success:error:))
        
    }
    
    //reloads data
    @IBAction func reloadData(_ sender: Any) {
        //removing annotations
        setLoggion(true)
        
        
        mapView.removeAnnotations(mapView.annotations)
        
        NetworkRequests.getStudentLocation { (studentLocation, error) in
            //saving the data on data object
            DataModel.studentLocations = studentLocation
            //calling a helper method that formats the data in the way that map can use and adding the data to map
            self.mapView.addAnnotations(StudentDataForMapAndTable.studentFormatedData())
            
            self.setLoggion(false)
            
        }
        
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
        //if hasStudentPosted is false it means that students has not posted
        // if the student has posted then an alert will appear
        if hasStudentPosted {
            overrideLocation()
        } else {
            //This is the option when the user has not posted anything before
            
            NetworkRequests.Auth.checkIfStudentPostedAlready = hasStudentPosted
            
            performSegue(withIdentifier: "AddNewPinViewController", sender: self)
        }
        
    }
    //These method give users an alert when they have a pin on the map already
    
    func overrideLocation()  {
        let alert = UIAlertController(title: "You Have Already Posted a Student Location. Would You Like to Overwrite You Current Location?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: {(action) in
            self.transferToOverWriteLocation()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func transferToOverWriteLocation() {
        
        NetworkRequests.Auth.checkIfStudentPostedAlready = hasStudentPosted
        
        performSegue(withIdentifier: "AddNewPinViewController", sender: self)
    }
    
    //This method is completion handler to delete session and log out
    
    func handleSessionDelete(success: Bool, error: Error?) {
        if success {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginNavigationController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            
            //to cHAnge the root view controller calling the object created in scene delegete
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(LoginNavigationController)
        } else {
            print("Unable to logout!")
        }
    }
    
    // Method to show the activity indicatior
    
    func setLoggion(_ logingIP: Bool) {
        
        if logingIP {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
    }
    
    
    // MARK: TableView Setup
    // This method controls the look of the pins and displays the data in a better format
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Method to open safari when user taps the pin
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                guard let url = URL(string: toOpen) else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
        }
    }
    
    
    
}
