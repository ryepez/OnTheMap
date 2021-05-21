//
//  LocationMapViewController.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/14/21.
//

import UIKit
import MapKit

class LocationMapViewController: UIViewController, MKMapViewDelegate  {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitude =  NetworkRequests.Auth.latitude
        let longitude = NetworkRequests.Auth.longitude
        let nameLocation = NetworkRequests.Auth.location
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        //setting variable
        // Do any additional setup after loading the view.
        //setting the initial location
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        mapView.centerToLocation(initialLocation)
        
        //adding the pin
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = nameLocation
        mapView.addAnnotation(annotation)
        //selects the first annotation so when going to the screen it shows selected
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
        
        print(NetworkRequests.Auth.checkIfStudentPostedAlready!)
    }
    
    
    // this method controls the look of the pins and displays the data in a better format
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func handlePostLocation(success: Bool, error: Error?) {
        if success {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            //to cHAnge the root view controller calling the object created in scene delegete
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        } else {
            //alert
            showAlert(alertText: "Failure to post your Location", alertMessage: "Unable post right now. Please try later")
        }
    }
    @IBAction func finishAction(_ sender: UIButton) {
        // unrapping optional
        guard let  checkIfStudentPostedAlready = NetworkRequests.Auth.checkIfStudentPostedAlready else {
            print("something went wrong when check if student has posted before")
            return
        }
        
        // the student posted alredy so we will replace the data with a PUT request
        
        if checkIfStudentPostedAlready {
            NetworkRequests.studentLocationPUT(completion: handlePostLocation(success:error:))
        } else {
            // the student has never posted before so regular post
            NetworkRequests.postStudentLocation(completion: handlePostLocation(success:error:))
        }
        
        
        
        
    }
    


}

extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }

}


